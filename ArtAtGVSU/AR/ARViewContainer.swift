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

/// ARKit session delegate that materializes a looping video plus optional model
/// for each detected artwork and bounds memory with an LRU of active overlays.
final class ARVideoSessionCoordinator: NSObject, ARSessionDelegate, Logging {
    weak var arView: ARView?

    private let artworksByImageName: [String: Artwork]
    /// Caps how many artwork overlays (each a video plane and any model) stay
    /// live at once; the rest are torn down least-recently-seen first.
    private let maxActiveOverlays: Int

    private var entities: [UUID: ARArtworkEntity] = [:]
    /// Anchor identifiers ordered least- to most-recently seen.
    private var lruOrder: [UUID] = []

    init(artworksByImageName: [String: Artwork], maxActiveOverlays: Int = 4) {
        self.artworksByImageName = artworksByImageName
        self.maxActiveOverlays = maxActiveOverlays
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for case let imageAnchor as ARImageAnchor in anchors {
            addOverlay(for: imageAnchor)
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for case let imageAnchor as ARImageAnchor in anchors {
            if let entity = entities[imageAnchor.identifier] {
                if imageAnchor.isTracked {
                    markRecentlyUsed(imageAnchor.identifier)
                }
                entity.setTracked(imageAnchor.isTracked)
            } else if imageAnchor.isTracked {
                // The overlay was LRU-evicted while away; ARKit keeps the anchor and
                // won't fire didAdd again, so rebuild it here on re-approach.
                addOverlay(for: imageAnchor)
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

    // MARK: - Overlay lifecycle

    private func addOverlay(for imageAnchor: ARImageAnchor) {
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
        let entity = ARArtworkEntity(physicalSize: imageAnchor.referenceImage.physicalSize)
        entity.anchorEntity = anchorEntity
        anchorEntity.addChild(entity.videoPlane)
        arView.scene.addAnchor(anchorEntity)

        entities[imageAnchor.identifier] = entity
        markRecentlyUsed(imageAnchor.identifier)
        evictIfNeeded()

        Task { @MainActor in
            do {
                let localURL = try await ARMediaCache.shared.localURL(for: videoURL)
                entity.startVideo(url: localURL)
            } catch {
                logger.error("Failed to load AR video for \(artwork.id, privacy: .public): \(error.localizedDescription, privacy: .public)")
            }
        }

        guard let modelURL = artwork.arModel else { return }

        Task { @MainActor in
            do {
                let localURL = try await ARMediaCache.shared.localURL(for: modelURL)
                let model = try await Entity(contentsOf: localURL)
                entity.setModel(model)
            } catch {
                logger.error("Failed to load AR model for \(artwork.id, privacy: .public): \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    private func markRecentlyUsed(_ anchorID: UUID) {
        lruOrder.removeAll { $0 == anchorID }
        lruOrder.append(anchorID)
    }

    private func evictIfNeeded() {
        while lruOrder.count > maxActiveOverlays {
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
