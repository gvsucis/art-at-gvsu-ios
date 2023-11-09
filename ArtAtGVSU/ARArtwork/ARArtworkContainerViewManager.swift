//
//  ARArtworkContainerViewManager.swift
//  ArtAtGVSU
//
//  Created by Andromeda on 10/5/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import ARKit
import RealityKit
import AVFoundation
import Combine


final class ARArtworkContainerViewManager: ObservableObject {
    var type: String = "artwork"
    private var subscriptions: Set<AnyCancellable> = []
    var arView = ArtworkCustomARView()
    var audioPlayer: AVAudioPlayer!
    var boxEntity: ModelEntity!
    var sculptureEntity: ModelEntity!
    var textEntity: ModelEntity!
    var avPlayerLooper: AVPlayerLooper!
    var imageAnchorToEntity: [ARImageAnchor: AnchorEntity] = [:]
    
    private let resourceLoader = ResourceLoader()
    

   func resetTrackingConfiguration(options: ARSession.RunOptions = [],  artwork: ARArtwork) {
       if (artwork.type == "artwork") {
           arView.worldTrackingConfiguration.maximumNumberOfTrackedImages = 1
           var s = Set<ARReferenceImage>()
           s.insert(artwork.refimg!)
           arView.worldTrackingConfiguration.detectionImages = s
           
       } else {
           guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Alten", bundle: nil) else {
               fatalError("Missing expected asset catalog resources.")
           }

           arView.worldTrackingConfiguration.detectionObjects = referenceObjects
       }
       
       arView.session.run(
         arView.worldTrackingConfiguration,
          options: options)
   }
    
    // 1
    func appendTextToScene(anchor: ARAnchor, text: String) {
        print("appendTextToScene: ", textEntity)
        if textEntity != nil {
            return
        }

       let textMeshResource = MeshResource.generateText(
          text,
          extrusionDepth: 0.003,
          font: UIFont.systemFont(ofSize: 0.02),
          alignment: .center)
  
       textEntity = ModelEntity(
          mesh: textMeshResource,
          materials: [
            SimpleMaterial(color: .white, isMetallic: false)
          ]
       )
        

       let anchorEntity = AnchorEntity(anchor: anchor)
//       anchorEntity.transform.translation.x = textMeshResource.bounds.extents.x
        
//        let objectAnchor = (anchor as? ARImageAnchor)
//        anchorEntity.transform.translation.y = objectAnchor.referenceImage..y
       anchorEntity.addChild(textEntity)
    
       arView.scene.anchors.append(anchorEntity)
    }
    
    func addBox(anchor: ARAnchor) {
        if boxEntity != nil {
            return
        }
        guard let objectAnchor = (anchor as? ARObjectAnchor) else {
            print("ARAnchor is not of object type")
            return
        }
        
        var material = PhysicallyBasedMaterial()
           material.baseColor = PhysicallyBasedMaterial.BaseColor(tint:.orange)
           material.roughness = PhysicallyBasedMaterial.Roughness(floatLiteral: 0.4)
           material.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 1.0)
        
//        let material = SimpleMaterial.init(color: .red,roughness: 1,isMetallic: true)

        let box = MeshResource.generateBox(size: 0.02) // Generate mesh
        boxEntity = ModelEntity(mesh: box, materials: [material])

        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.name = "box"
//        anchorEntity.position = [0,0,0]
        
        anchorEntity.addChild(boxEntity)
        arView.scene.anchors.append(anchorEntity)
        
        let pointLight = PointLightComponent(color: .red,
                                             intensity: 100000,
                                     attenuationRadius: 20)
        boxEntity.components.set(pointLight)
    }
    
    func makeVideoArt(anchor: ARAnchor, videoUrl: URL) {
        print("makevideoart")
        if let imageAnchor = anchor as? ARImageAnchor {
            let width = Float(imageAnchor.referenceImage.physicalSize.width)
            let height = Float(imageAnchor.referenceImage.physicalSize.height)
            
            let videoScreen = createVideoScreen(width: width, height: height, video: videoUrl)
            
            let imganc = AnchorEntity(anchor: imageAnchor)
            imganc.transform.matrix = anchor.transform
            
            let rotationAngle = simd_quatf(angle: GLKMathDegreesToRadians(-90), axis: SIMD3(x: 1, y: 0, z: 0) )
            
            videoScreen.setOrientation(rotationAngle, relativeTo: imganc)
            
            imganc.addChild(videoScreen)
            
            arView.scene.addAnchor(imganc)
        }
    }
    
    func asynclo(anchor: ARAnchor, modelUrl: URL, transform: SCNMatrix4) {
        let anchorEntity = AnchorEntity()
//        anchorEntity.position = anchor.
        arView.scene.anchors.append(anchorEntity)
        
        ModelEntity.loadAsync(contentsOf: modelUrl).sink(receiveCompletion: { loadCompletion in
            switch loadCompletion {
            case .failure(let error):
                print("Unable to load model: \(error.localizedDescription)")
            case .finished:
                print("Load async finished")
                break
            }
        }, receiveValue: { entity in
            entity.scale = SIMD3(x: transform.m11, y: -transform.m22, z: -transform.m33)
            
            let animation = entity.availableAnimations[0]
            entity.playAnimation(animation.repeat(duration: .infinity), transitionDuration: 1.25, startsPaused: false)
            
            if let anchorim = anchor as? ARImageAnchor {
                anchorEntity.transform.matrix = anchor.transform
                self.imageAnchorToEntity[anchorim] = anchorEntity
            }
            
            DispatchQueue.global().async {
               for child in entity.children {
                   child.scale = SIMD3(x: transform.m11, y: -transform.m22, z: -transform.m33)
                   
                   anchorEntity.addChild(child)
                   sleep(1)
               }
              let a = anchorEntity.availableAnimations[0]
              anchorEntity.playAnimation(a.repeat(duration: .infinity), transitionDuration: 1.25, startsPaused: false)
            }
        }).store(in: &subscriptions)
    }
    
    func createVideoScreen(width: Float, height: Float, video: URL) -> ModelEntity {
        let plane = MeshResource.generatePlane(width: width, height: height)
        
        let videoItem = createVideoItem(filename: video)
        let videoMaterial = createVideoMaterial(with: videoItem)
        
        let videoScreenModel = ModelEntity(mesh: plane, materials: [videoMaterial])
        
        return videoScreenModel
    }
    
    func createVideoMaterial(with videoItem: AVPlayerItem) -> VideoMaterial {
        
        let queuePlayer = AVQueuePlayer()
        avPlayerLooper = AVPlayerLooper(
          player: queuePlayer,
          templateItem: videoItem
        )
        
        let videoMaterial = VideoMaterial(avPlayer: queuePlayer)
        
        queuePlayer.play()
        
        return videoMaterial
    }
    
    func createVideoItem(filename:URL) -> AVPlayerItem {
       let asset = AVAsset(url: filename)
       let item = AVPlayerItem(asset: asset)

        return item
    }
    
    
    func nodescene() {
        
    }
    
    func addCup(anchor: ARAnchor,path: URL, transform: SCNMatrix4) {
            // Create a new cup to place at the tap location
            let cup = try? Entity.load(contentsOf: path)
        
        print("Animations: ", cup?.availableAnimations)
        
        let cow = cup?.availableAnimations[0]
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        
//        cup?.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
//        cup?./*transform = S*/
//        cup?.setScale(SIMD3(x: transform.m11, y: transform.m22, z: transform.m33), relativeTo: nil)
        cup?.scale = SIMD3(x: transform.m11, y: transform.m22, z: transform.m33)
        
//        cup!.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
        
        cup?.playAnimation((cow?.repeat(duration: .infinity))!, transitionDuration: 1.25, startsPaused: false)
//            do {
//                cup = try resourceLoader.createCup(path: path)
//            } catch let error {
//                print("Failed to create cup: \(error)")
//                return
//            }
//            
//            defer {
//                // Get translation from transform
//                let column = worldTransform.columns.3
//                let translation = SIMD3<Float>(column.x, column.y, column.z)
//                
//                // Move the cup to the tap location
//                cup.setPosition(translation, relativeTo: nil)
//            }
            
            // If there is not already an anchor here, create one

            
        anchorEntity.addChild(cup!)
            arView.scene.addAnchor(anchorEntity)
            
            // Add the cup to the existing anchor
        anchorEntity.addChild(cup!)
        }
    
    
    func makeVideoNode(anchor: ARAnchor) {
        if sculptureEntity != nil {
            return
        }
        print("makeVideoNode")
        let url = Bundle.main.url(forResource: "art.scnassets/alten_face2",
                                           withExtension: "mov")!

        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        // Create a Material and assign it to your model entity
        let player = AVPlayer()
        let material = VideoMaterial(avPlayer: player)
        let playbackSpeed: Float = 0.2 // 2x playback speed

//         Create a timer to update the texture at a specific frame rate
//        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1.0 / (30.0 * playbackSpeed)), repeats: true) { _ in
//            // Calculate the current frame to display based on playback speed
//            let currentTime = material.avPlayer?.currentTime()
//            let newTime = Float(CMTimeGetSeconds(currentTime!)) + (1.0 / 30.0) * playbackSpeed // Assuming 30 FPS video
////            print("New time: ", newTime)
//            material.avPlayer?.rate = 2.5
//        }
        
//        timer.fire()
        material.avPlayer?.rate = 2.5
        
        
        let track = asset.tracks(withMediaType: AVMediaType.video).first
        let size = track?.naturalSize.applying(track!.preferredTransform)
        
        
        guard let objectAnchor = (anchor as? ARObjectAnchor) else {
            print("ARAnchor is not of object type")
            return
          
        }
        
        print("Video size: ", size)
        print("Anchor center: ", objectAnchor.referenceObject.center)
        print("Anchor extent: ", objectAnchor.referenceObject.extent)
        
        
        // 2. Calculate size based on planeNode's bounding box.
//        let (min, max) = anchor.boundingBox
        let max = objectAnchor.referenceObject.extent
        let min = objectAnchor.referenceObject.center
        let sizeanchor = SCNVector3Make(max.x - min.x, max.y - min.y, max.z - min.z)
            
        // 3. Calculate the ratio of difference between real image and object size.
        // Ignore Y axis because it will be pointed out of the image.
        let widthRatio = Float(size!.width*0.0002645833)/sizeanchor.x
        let heightRatio = Float(size!.height*0.0002645833)/sizeanchor.z
//        // Pick smallest value to be sure that object fits into the image.
        let finalRatio = CGFloat([widthRatio, heightRatio].min()!)
        
        print("FINAL ASPECT RATION: ", finalRatio, objectAnchor.referenceObject.scale)
        
            
        // 4. Set transform from imageAnchor data.
        let finalRatiol = [sizeanchor.x, sizeanchor.z].min()! - 0.02
        print("FINAL ASPECT RATION-------: ", finalRatiol)
         
        let mesh = MeshResource.generatePlane(width: finalRatiol, height: finalRatiol)
        let material2 = SimpleMaterial.init(color: .red,roughness: 1,isMetallic: true)
        sculptureEntity = ModelEntity(mesh: mesh, materials: [material, material2])
        
        let pointLight2 = PointLightComponent(color: .yellow,
                                             intensity: 100000,
                                     attenuationRadius: 20)
        sculptureEntity.components.set(pointLight2)
        
      
        
       // Tell the player to load and play
       player.replaceCurrentItem(with: playerItem)
       player.play()

        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.position.x = objectAnchor.referenceObject.center.x + 0.002
        
        let pointLight = PointLight() // pointLight is an entity
        pointLight.light.intensity = 1000000 // pointLight.light is a component
        pointLight.light.color = .blue
        pointLight.light.attenuationRadius = 5
        pointLight.position = sculptureEntity.position
        pointLight.position.z = pointLight.position.z - 0.05
        sculptureEntity.components.set(pointLight2)

        anchorEntity.addChild(pointLight)

        anchorEntity.addChild(sculptureEntity)
        arView.scene.anchors.append(anchorEntity)
        
//        loadAudio(entity:model)
        loadAudio2()
    }
    
    func loadAudio3() {
        do {
            try AVAudioSession.sharedInstance()
                .setCategory(.playback, mode: .default, options: [])
        } catch {
            print(error)
        }
    }
    
    func loadAudio2() {
        guard let path = Bundle.main.path(forResource: "art.scnassets/alten_speech", ofType:"m4a") else {
               return }
           let url = URL(fileURLWithPath: path)

           do {
               loadAudio3()


               if let url = Bundle.main.url(forResource: "art.scnassets/alten-speech", withExtension: "mp3") {
                   audioPlayer = try AVAudioPlayer(contentsOf: url)
                   audioPlayer.volume = 1.0
                   audioPlayer.play()
                   print("Is audio currentTime: ",audioPlayer.currentTime)
                   print("Is audio duration: ",audioPlayer.duration)
                   print("Is audio duration: ",audioPlayer.isPlaying)
               }
               
//               print("Is audio playing: ",player.isPlaying)
               
           } catch let error {
               print(error.localizedDescription)
           }
    }
    
    fileprivate func loadAudio(entity: Entity) {
        do {
            
            
            let audioResource = try AudioFileResource.load(
                                               named: "art.scnassets/alten-speech.mp3",
                                               in: nil,
                                               inputMode: .spatial,
                                     loadingStrategy: .preload,
                                          shouldLoop: true)
            print(audioResource)
            let entity1 = Entity()

//            let audioController = entity.playAudio(audioResource)
//            print(audioController)
////            audioController.speed = 1
////            audioController.gain = 30
////            audioController.play()
//            print(audioController.isPlaying)
        } catch {
            print("Get error while loading audio...", error)
            print(error.localizedDescription)
        }
    }
    
    

}
