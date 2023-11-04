import SwiftUI
import ARKit
import RealityKit
import AVFoundation

struct ARContainerView: UIViewRepresentable {
    var sessionRunOptions: ARSession.RunOptions
    var artwork: Artwork
    @ObservedObject var containerViewManager = ARArtworkContainerViewManager()
    
//    private let worldTrackingConfiguration: ARWorldTrackingConfiguration = {
//       let worldTrackingConfiguration = ARWorldTrackingConfiguration()
//        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth)  {
//            
//            print("Device allows frame semantics")
//            worldTrackingConfiguration.frameSemantics.insert(.personSegmentationWithDepth)
//        }
//
//       worldTrackingConfiguration.planeDetection = .horizontal
//       worldTrackingConfiguration.isLightEstimationEnabled = false
//       return worldTrackingConfiguration
//    }()
    
     func makeCoordinator() -> Coordinator {
//        print("[INFO] [makeCoordinator]")
        Coordinator(self)
     }
    
    static func dismantleUIView(
        _ uiView: Self.UIViewType,
        coordinator: Self.Coordinator
    ){
        print("Dismantle....")
        coordinator.parent.containerViewManager.arView.session.pause()
        print("Pausing session....")
        coordinator.parent.containerViewManager.audioPlayer.pause()
        print("Pausing audio....")
    }
    

    class Coordinator: NSObject, ARSessionDelegate {
       var parent: ARContainerView

       init(_ parent: ARContainerView) {
          self.parent = parent
       }
        
       func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
           print("[INFO] [makeCoordinator::session:didAdd] ", anchors)
          for anchor in anchors {
              guard let objectAnchor = (anchor as? ARObjectAnchor) else {
                  continue
              }
            
            print("Found ARObjectAnchor \(objectAnchor.name)")
            
              parent.containerViewManager.appendTextToScene(anchor: anchor, text: parent.artwork.name)
              parent.containerViewManager.makeVideoNode(anchor: anchor)
              parent.containerViewManager.addBox(anchor: anchor)
          }
       }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//            print("didUpdate")
            
           
//            let currentDate = Date()
//            let calendar = Calendar.current
//            let seconds = calendar.component(.second, from: currentDate)
//            
//            let modResult = Int(seconds) % 5
//            
//            print("Modresult: ", modResult, " seconds", seconds)
            
//            print("View avg color: ", parent.containerViewManager.arView.getAverageColor())
//            
//            if (modResult == 0) {
//                print("Changing box color")
//                let color = parent.containerViewManager.arView.getAverageColor()
//                parent.containerViewManager.boxEntity.model?.materials[0] = UnlitMaterial(color: color ?? UIColor(Color.random()))
//                
//            }
            
            
        }
    }
   
   
   // 3
   func makeUIView(context: Context) -> ArtworkCustomARView {
       print("[INFO] [makeUIView]")
       containerViewManager.arView.didTapView = didTapView(_:); containerViewManager.resetTrackingConfiguration()
       containerViewManager.arView.session.delegate = context.coordinator
       return containerViewManager.arView
   }
   // 4
   func updateUIView(_ uiView: ArtworkCustomARView, context: Context) {
   }
   // 5
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
