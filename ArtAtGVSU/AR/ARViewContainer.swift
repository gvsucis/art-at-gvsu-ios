//
//  ARViewContainer.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/19/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import RealityKit
import ARKit
import AVFoundation

/// Hosts a RealityKit `ARView` running a single image-tracking session over
/// every AR artwork in the gallery. As the visitor walks up to a piece, its
/// video lights up; the coordinator keeps only a few videos live at a time.
struct ARViewContainer: UIViewRepresentable {
    let referenceImages: Set<ARReferenceImage>
    let artworksByImageName: [String: Artwork]

    func makeCoordinator() -> ARVideoSessionCoordinator {
        ARVideoSessionCoordinator(artworksByImageName: artworksByImageName)
    }

    func makeUIView(context: Context) -> ARView {
        activateAudioSession()

        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        arView.session.delegate = context.coordinator

        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        // Pieces hang far enough apart that only one is ever in frame.
        configuration.maximumNumberOfTrackedImages = 1
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    static func dismantleUIView(_ uiView: ARView, coordinator: ARVideoSessionCoordinator) {
        uiView.session.pause()
        coordinator.teardownAll()
        deactivateAudioSession()
    }

    /// Plays AR video audio like music: through the silent switch, governed by
    /// the volume buttons. Active only while the AR view is on screen.
    private func activateAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .moviePlayback)
        try? session.setActive(true)
    }

    /// Restores the app's previous audio behavior when leaving AR.
    private static func deactivateAudioSession() {
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

/// ARKit session delegate that materializes a looping video for each detected
/// artwork and bounds memory with an LRU of active videos.
final class ARVideoSessionCoordinator: NSObject, ARSessionDelegate, Logging {
    weak var arView: ARView?

    private let artworksByImageName: [String: Artwork]
    private let maxActiveVideos: Int

    private var entities: [UUID: ARVideoEntity] = [:]
    /// Anchor identifiers ordered least- to most-recently seen.
    private var lruOrder: [UUID] = []

    init(artworksByImageName: [String: Artwork], maxActiveVideos: Int = 4) {
        self.artworksByImageName = artworksByImageName
        self.maxActiveVideos = maxActiveVideos
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for case let imageAnchor as ARImageAnchor in anchors {
            addVideo(for: imageAnchor)
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for case let imageAnchor as ARImageAnchor in anchors {
            guard let entity = entities[imageAnchor.identifier] else { continue }
            if imageAnchor.isTracked {
                markRecentlyUsed(imageAnchor.identifier)
                entity.play()
            } else {
                entity.pause()
            }
        }
    }

    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors {
            teardown(anchorID: anchor.identifier)
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        logger.error("AR session failed: \(error.localizedDescription, privacy: .public)")
    }

    func teardownAll() {
        entities.values.forEach { $0.teardown() }
        entities.removeAll()
        lruOrder.removeAll()
    }

    // MARK: - Video lifecycle

    private func addVideo(for imageAnchor: ARImageAnchor) {
        guard let arView,
              entities[imageAnchor.identifier] == nil,
              let name = imageAnchor.referenceImage.name,
              let artwork = artworksByImageName[name],
              let videoURL = artwork.arDigitalAsset else {
            return
        }

        // Track the ARKit anchor by identifier — RealityKit keeps the entity's
        // transform in sync with the detected image as it updates.
        let anchorEntity = AnchorEntity(.anchor(identifier: imageAnchor.identifier))
        let entity = ARVideoEntity(physicalSize: imageAnchor.referenceImage.physicalSize)
        entity.anchorEntity = anchorEntity
        anchorEntity.addChild(entity.modelEntity)
        arView.scene.addAnchor(anchorEntity)

        entities[imageAnchor.identifier] = entity
        markRecentlyUsed(imageAnchor.identifier)
        evictIfNeeded()

        Task { @MainActor in
            do {
                let localURL = try await ARMediaCache.shared.localURL(for: videoURL)
                entity.start(url: localURL)
            } catch {
                logger.error("Failed to load AR video for \(artwork.id, privacy: .public): \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    private func markRecentlyUsed(_ anchorID: UUID) {
        lruOrder.removeAll { $0 == anchorID }
        lruOrder.append(anchorID)
    }

    private func evictIfNeeded() {
        while lruOrder.count > maxActiveVideos {
            let victim = lruOrder.removeFirst()
            entities[victim]?.teardown()
            entities[victim] = nil
        }
    }

    private func teardown(anchorID: UUID) {
        entities[anchorID]?.teardown()
        entities[anchorID] = nil
        lruOrder.removeAll { $0 == anchorID }
    }
}
