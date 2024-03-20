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

    var referenceImages: Set<ARReferenceImage> = Set<ARReferenceImage>()

    var videoNode: SKVideoNode!
    var videoPlayer: AVQueuePlayer!
    var videoLooper: AVPlayerLooper?

    var asset: MDLAsset?
    var artModel: SCNNode?

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

            arImage.validate { error in
                if error != nil {
                    return
                }
            }

            self.referenceImages.insert(arImage)

            self.runImageTrackingSession(with: self.referenceImages, runOptions: [.resetTracking, .removeExistingAnchors])
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        runImageTrackingSession(with: self.referenceImages)
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

    func placeForegroundObject(_ imageAnchor: ARImageAnchor, _ node: SCNNode) {
        guard let modelParent = sceneContainer?.childNode(withName: "model", recursively: true) else  {
            return
        }

        guard let arModel = self.arAsset.models.first else {
            return
        }

        guard let model = try? SCNScene(url: arModel.url, options: [.checkConsistency: true]).rootNode.childNodes.first else {
            return
        }

        modelParent.addChildNode(model)
        modelParent.geometry?.firstMaterial?.lightingModel = .physicallyBased

        self.artModel = modelParent

        modelParent.isHidden = false
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
        self.artModel = nil

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
        guard let container = sceneContainer else {
            return
        }

        container.removeFromParentNode()
        node.addChildNode(container)
        container.isHidden = false

        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }

        placeLivingPainting(imageAnchor, node)
        DispatchQueue.main.async {
            self.placeForegroundObject(imageAnchor, node)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }

        if imageAnchor.isTracked {
            if videoNode != nil {
                videoNode.play()
            }

            self.artModel?.isHidden = false

            if self.timer != nil {
                timer.invalidate()
            }
        } else {
            if videoNode != nil {
                videoNode.pause()
            }

            DispatchQueue.main.async {
              self.timer = Timer.scheduledTimer(withTimeInterval: 40, repeats: false) { timer in
                self.artModel?.isHidden = true
              }
            }
        }
    }

    private func placeLivingPainting(_ imageAnchor: ARImageAnchor, _ node: SCNNode) {
        guard let video = sceneContainer?.childNode(withName: "video", recursively: true) else {
            return
        }

        let referenceImage = imageAnchor.referenceImage
        guard let assetVideo = arAsset?.video else {
            return
        }

        let asset = AVAsset(url: assetVideo)
        let playerItem = AVPlayerItem(asset: asset)
        videoPlayer = AVQueuePlayer(playerItem: playerItem)
        videoLooper = AVPlayerLooper(player: videoPlayer, templateItem: playerItem)
        videoNode = SKVideoNode(avPlayer: videoPlayer)

        let videoScene = SKScene(size: CGSize(width: 720.0, height: 1280.0))
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode.size = videoScene.size
        videoNode.play()
        videoScene.addChild(videoNode)

        video.geometry?.firstMaterial?.diffuse.contents = videoScene
        video.geometry?.firstMaterial?.shininess = 0
        video.geometry?.materials.first?.diffuse.intensity = 1
        video.geometry?.materials.first?.lightingModel = .phong
        video.scale = SCNVector3(x: Float(referenceImage.physicalSize.width), y: Float(referenceImage.physicalSize.height), z: 1.0)
        video.position = node.position
        video.isHidden = false
    }

    var sceneContainer: SCNNode? {
        sceneView.scene.rootNode.childNode(withName: "container", recursively: true)
    }
}
