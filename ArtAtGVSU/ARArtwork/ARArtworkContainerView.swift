import SwiftUI
import ARKit
import RealityKit
import AVFoundation

struct ARContainerView: UIViewRepresentable {
    var sessionRunOptions: ARSession.RunOptions
    var artwork: Artwork
    var arArtwork: ARArtwork
    @ObservedObject var containerViewManager = ARArtworkContainerViewManager()
    
     func makeCoordinator() -> Coordinator {
         Coordinator(self)
     }
    
    static func dismantleUIView(
        _ uiView: Self.UIViewType,
        coordinator: Self.Coordinator
    ){
        print("Dismantle....")
        coordinator.parent.containerViewManager.arView.session.pause()
        
        print("Pausing session....")
        coordinator.parent.containerViewManager.audioPlayer?.pause()
        print("Pausing audio....")
    }
    

    class Coordinator: NSObject, ARSessionDelegate {
       var parent: ARContainerView

        init(_ parent: ARContainerView) {
          self.parent = parent
       }
        
        
       func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//           print("[INFO] [makeCoordinator::session:didAdd] ", anchors)
          for anchor in anchors {
              if (anchor is ARImageAnchor) {
                  print("Anchor IMAGE")
                  let objectAnchor = (anchor as? ARImageAnchor)
                  
                  print("Found ARObjectAnchor \(objectAnchor?.name) showing video: \(parent.arArtwork.video)")
                  print("AFAF: ", parent.arArtwork.models[0].metadata)
                  parent.containerViewManager.appendTextToScene(anchor: anchor, text: parent.artwork.name)
                  parent.containerViewManager.makeVideoArt(anchor: anchor, videoUrl: parent.arArtwork.video!)
                  parent.containerViewManager.asynclo(anchor: anchor, modelUrl: parent.arArtwork.models[0].url, transform: parent.arArtwork.models[0].metadata.transform!)
//                  parent.containerViewManager.addCup(anchor: anchor, path: parent.arArtwork.models[0].url, transform: parent.arArtwork.models[0].metadata.transform!)
              } else if (anchor is ARObjectAnchor) {
                  parent.containerViewManager.makeVideoNode(anchor: anchor)
                  parent.containerViewManager.addBox(anchor: anchor)
              }
          }
       }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            anchors.compactMap { $0 as? ARImageAnchor }.forEach {
                let anchorEntity = parent.containerViewManager.imageAnchorToEntity[$0]
                anchorEntity?.transform.matrix = $0.transform
            }
        }
    }
   

   func makeUIView(context: Context) -> ArtworkCustomARView {
       print("[INFO] [makeUIView]")
       containerViewManager.arView.didTapView = didTapView(_:); containerViewManager.resetTrackingConfiguration(options: sessionRunOptions,artwork: arArtwork)
       containerViewManager.arView.session.delegate = context.coordinator
       
       print("Session configuration: ", containerViewManager.arView.worldTrackingConfiguration)
       
       print("Type of artwork: ", artwork.arType)
       return containerViewManager.arView
   }

   func updateUIView(_ uiView: ArtworkCustomARView, context: Context) {
   }

   func didTapView(_ sender: UITapGestureRecognizer) {
       print("[INFO] [didTapView]")
      let arView = containerViewManager.arView
      let tapLocation = sender.location(in: arView)
      let raycastResults = arView.raycast(
         from: tapLocation,
         allowing: .estimatedPlane,
         alignment: .horizontal)
      guard let firstRaycastResult = raycastResults.first else { return }
      let anchor = ARAnchor(name: "anchorName",
                            transform: firstRaycastResult.worldTransform)
      arView.session.add(anchor: anchor)
   }
}


public extension Color {

    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}
