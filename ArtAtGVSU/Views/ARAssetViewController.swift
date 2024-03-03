//
//  ARAssetViewController.swift
//  ArtAtGVSU
//
//  Created by Jonathan Engelsma on 8/17/22.
//  Copyright © 2022 Applied Computing Institute. All rights reserved.
//

import UIKit
import SceneKit
import SceneKit.ModelIO
import ARKit
import Foundation
import SwiftUI

class ARAssetViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    var arAsset: ARAsset!

    var newReferenceImages: Set<ARReferenceImage> = Set<ARReferenceImage>()

    var videoNode: SKVideoNode!
    var videoPlayer: AVQueuePlayer!
    var videoLooper: AVPlayerLooper?

    var asset: MDLAsset?
    var objNode: SCNNode?

    let angle = CGFloat(10) * CGFloat.pi / 182.0

    private var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.scene = SCNScene(named: "art.scnassets/artwork.scn")!
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true

        self.loadImageFrom() { (result) in
            guard let cgImage = result.cgImage else { return }

            let imageWidth = CGFloat(cgImage.width) * 0.0002645833

            let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: imageWidth)
            arImage.name = "ARImage-\(self.arAsset.id)"

            arImage.validate { [weak self] (error) in
                if error != nil {
                    return
                }
            }

            self.newReferenceImages.insert(arImage)

            self.runImageTrackingSession(with: self.newReferenceImages, runOptions: [.resetTracking, .removeExistingAnchors])
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        runImageTrackingSession(with: self.newReferenceImages)
    }

    func loadImageFrom(completionHandler: @escaping(UIImage)->()) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: self!.arAsset.referenceImage!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completionHandler(image);
                    }
                }
            }
        }
    }

    // MARK: - ImageTrackingSession
    private func runImageTrackingSession(with trackingImages: Set<ARReferenceImage>,
                                         runOptions: ARSession.RunOptions = [.removeExistingAnchors]) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.maximumNumberOfTrackedImages = 1
        configuration.detectionImages = trackingImages
        sceneView.session.run(configuration, options: runOptions)
    }

    @IBAction func dismissARView(_ sender: UIButton) {
        if self.timer != nil {
            timer.invalidate()
        }
        self.objNode = nil

        self.dismiss(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()

        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }

        guard let referenceImage = ((anchor as? ARImageAnchor)?.referenceImage) else { return }

        guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: true) else {
            return
        }

        container.removeFromParentNode()
        node.addChildNode(container)
        container.isHidden = false

        let asset = AVAsset(url: arAsset!.video!)
        let item = AVPlayerItem(asset: asset)
        videoPlayer = AVQueuePlayer(playerItem: item)
        videoLooper = AVPlayerLooper(player: videoPlayer, templateItem: item)

        let videoScene = SKScene(size: CGSize(width: 720.0, height: 1280.0))
        videoNode = SKVideoNode(avPlayer: videoPlayer)

        videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
        videoNode.size = videoScene.size
        videoNode.yScale = -1
        videoNode.play()
        videoScene.addChild(videoNode)

        guard let video = container.childNode(withName: "video", recursively: true) else { return }
        video.geometry?.firstMaterial?.diffuse.contents = videoScene
        video.geometry?.firstMaterial?.shininess = 0
        video.geometry?.materials.first?.diffuse.intensity = 1
        video.geometry?.materials.first?.lightingModel = .phong

        video.scale = SCNVector3(x: Float(referenceImage.physicalSize.width), y: Float(referenceImage.physicalSize.height), z: 1.0)

        video.position = node.position

        guard let videoContainer = container.childNode(withName: "videoContainer", recursively: false) else { return }
        videoContainer.geometry?.firstMaterial?.shininess = 0

        videoContainer.runAction(SCNAction.sequence([SCNAction.wait(duration: 1.0), SCNAction.scale(to: 1.0, duration: 0.5)]))
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = (anchor as? ARImageAnchor) else { return }

        if self.objNode != nil {
            self.objNode?.scale = SCNVector3(1, -1, -1)
            self.objNode?.position = SCNVector3(node.position.x, node.position.y, node.position.z)
            self.objNode?.rotation = node.rotation
        }


        if imageAnchor.isTracked {
            if videoNode != nil {
                videoNode.play()
            }

            self.objNode?.isHidden = false

            if self.timer != nil {
                timer.invalidate()
            }
        } else {
            if videoNode != nil {
                videoNode.pause()
            }

            DispatchQueue.main.async {
              self.timer = Timer.scheduledTimer(withTimeInterval: 40, repeats: false) { timer in
                self.objNode?.isHidden = true
              }
            }
        }
    }
}
