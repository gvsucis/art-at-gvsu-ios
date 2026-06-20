//
//  ARVideoEntity.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/19/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import RealityKit
import AVFoundation

/// A looping video rendered on a plane sized to a detected artwork. Owns the
/// `AVPlayer` and `AVPlayerLooper` so their lifetimes are bounded by the
/// session's LRU cache.
///
/// All members touch RealityKit / AVFoundation, so callers must use this from
/// the main thread (ARKit delivers session callbacks there by default).
final class ARVideoEntity {
    let modelEntity: ModelEntity
    var anchorEntity: AnchorEntity?

    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    private(set) var isTornDown = false

    init(physicalSize: CGSize) {
        // The image lies in the anchor's x-z plane, so a width/depth plane lays
        // flat against it with no extra rotation.
        let mesh = MeshResource.generatePlane(
            width: Float(physicalSize.width),
            depth: Float(physicalSize.height)
        )
        // Placeholder until the stream is ready, keeps the surface from flashing.
        modelEntity = ModelEntity(mesh: mesh, materials: [UnlitMaterial(color: .black)])
    }

    /// Begins looping playback of the local video file. No-op if already
    /// evicted while the file was downloading.
    func start(url: URL) {
        guard !isTornDown else { return }

        let item = AVPlayerItem(url: url)
        let player = AVQueuePlayer(playerItem: item)
        let looper = AVPlayerLooper(player: player, templateItem: item)

        // NOTE: if the video appears mirrored or rotated on device, apply a
        // correcting rotation here (e.g. about the y-axis) — texture mapping on
        // a horizontal plane can't be verified outside a physical device.
        modelEntity.model?.materials = [VideoMaterial(avPlayer: player)]

        player.play()
        self.player = player
        self.looper = looper
    }

    func play() {
        guard !isTornDown else { return }
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func teardown() {
        isTornDown = true
        player?.pause()
        looper = nil
        player = nil
        anchorEntity?.removeFromParent()
        anchorEntity = nil
    }
}
