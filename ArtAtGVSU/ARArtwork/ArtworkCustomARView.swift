//
//  CustomARView2.swift
//  ArtAtGVSU
//
//  Created by Andromeda on 10/17/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation

import SwiftUI
import ARKit
import RealityKit

final class ArtworkCustomARView: ARView {
    // configuration
    let worldTrackingConfiguration: ARWorldTrackingConfiguration = {
        print("Configuring ar world tracking")
          let worldTrackingConfiguration = ARWorldTrackingConfiguration()
//        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Alten", bundle: nil) else {
//            fatalError("Missing expected asset catalog resources.")
//        }
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            print("SUPPORTS SCENE RECONSTRUCTION")
            worldTrackingConfiguration.sceneReconstruction = .mesh
        }
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth)  {
                print("Device allows frame semantics")
                worldTrackingConfiguration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
//        worldTrackingConfiguration.detectionObjects = referenceObjects
//          worldTrackingConfiguration.planeDetection = .horizontal
          worldTrackingConfiguration.isLightEstimationEnabled = false
          return worldTrackingConfiguration
       }()
    
//    func getAverageColor() -> UIColor? {
//            // Render the SceneKit scene to an image
//        print("Getting average image color")
//        
//            let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
//            let image = renderer.image { _ in
//                self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
//            }
//            
//            // Analyze the image to calculate the average color
//            let pixelCount = image.size.width * image.size.height
////            let totalColor = image.getPixelColorSum()
////            let averageColor = UIColor(red: totalColor.red / pixelCount, green: totalColor.green / pixelCount, blue: totalColor.blue / pixelCount, alpha: 1.0)
//        
//        
//        print("Returning average image color")
//            
//            return averageColor
//        }
   // 1
   let label: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   // 2
   var didTapView: ((_ sender: UITapGestureRecognizer) -> Void)?
   // 3
   @objc required dynamic init(frame frameRect: CGRect) {
      super.init(frame: frameRect)
      commonInit()
   }
   required init?(coder: NSCoder) {
      super.init(coder: coder)
      commonInit()
   }
   convenience init() {
      self.init(frame: .zero)
      commonInit()
   }
   private func commonInit() {
   }
}



final class ARContainerViewManager2: ObservableObject {
   // 2
   var arView = ArtworkCustomARView()
   // 3
   private let worldTrackingConfiguration: ARWorldTrackingConfiguration = {
      let worldTrackingConfiguration = ARWorldTrackingConfiguration()
      worldTrackingConfiguration.planeDetection = .horizontal
      worldTrackingConfiguration.isLightEstimationEnabled = false
      return worldTrackingConfiguration
   }()
   // 4
   func resetTrackingConfiguration(options: ARSession.RunOptions = []) {
      arView.session.run(
         worldTrackingConfiguration,
         options: options)
   }
    // 1
    func appendTextToScene(anchor: ARAnchor) {
       // 2
       let textMeshResource = MeshResource.generateText(
          "AppCoda.com\nx\nMastering ARKit",
          extrusionDepth: 0.02,
          font: UIFont.systemFont(ofSize: 0.08),
          alignment: .center)
       // 3
       let modelEntity = ModelEntity(
          mesh: textMeshResource,
          materials: [
            SimpleMaterial(color: .white, isMetallic: false)
          ]
       )
       // 4
       let anchorEntity = AnchorEntity(anchor: anchor)
       anchorEntity.transform.translation.x = -textMeshResource.bounds.extents.x / 2
       anchorEntity.addChild(modelEntity)
       // 5
       arView.scene.anchors.append(anchorEntity)
    }
}

