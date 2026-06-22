//
//  ARArtworkEntity.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/19/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import RealityKit
import AVFoundation

/// A detected artwork's AR overlay: a looping video on a plane plus an optional
/// 3D (USDZ) model, both anchored to the recognized image. Owns the AVPlayer
/// and loaded entities so the session's LRU can bound their lifetimes.
///
/// All members touch RealityKit / AVFoundation, so callers must use this from
/// the main thread (ARKit delivers session callbacks there by default).
final class ARArtworkEntity {
    let videoPlane: ModelEntity
    var anchorEntity: AnchorEntity?

    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    private var model: Entity?
    private var modelAnimations: [AnimationPlaybackController] = []
    private(set) var isTornDown = false

    init(physicalSize: CGSize) {
        // The image lies in the anchor's x-z plane, so a width/depth plane lays
        // flat against it with no extra rotation.
        let mesh = MeshResource.generatePlane(
            width: Float(physicalSize.width),
            depth: Float(physicalSize.height)
        )
        // Placeholder until the stream is ready, keeps the surface from flashing.
        videoPlane = ModelEntity(mesh: mesh, materials: [UnlitMaterial(color: .black)])
    }

    /// Begins looping playback of the local video file. No-op if already
    /// evicted while the file was downloading.
    func startVideo(url: URL) {
        guard !isTornDown else { return }

        let item = AVPlayerItem(url: url)
        let player = AVQueuePlayer(playerItem: item)
        let looper = AVPlayerLooper(player: player, templateItem: item)

        // NOTE: if the video appears mirrored or rotated on device, apply a
        // correcting rotation here (e.g. about the y-axis) — texture mapping on
        // a horizontal plane can't be verified outside a physical device.
        videoPlane.model?.materials = [VideoMaterial(avPlayer: player)]

        player.play()
        self.player = player
        self.looper = looper
    }

    /// An image anchor's local frame puts the image in its x-z plane with +y as
    /// the surface normal. USDZ models are authored y-up, so dropping one into the
    /// anchor unrotated pins its "up" to the image normal — the model lies flat and
    /// you view it from the top. Rotating -90° about x maps the model's y-up onto
    /// the image's vertical axis so it stands upright at eye level.
    ///
    /// If a model ends up upside down or facing away on device, flip this sign or
    /// add a y-axis turn — it can't be verified outside a physical device.
    private static let modelOrientationCorrection = simd_quatf(
        angle: -.pi / 2,
        axis: SIMD3<Float>(1, 0, 0)
    )

    /// Attaches a loaded USDZ model to the anchor alongside the video. No-op if
    /// already evicted while the model was downloading/loading.
    ///
    /// Per-artwork placement (scale, depth, position) is baked into each USDZ; the
    /// app only stands the model upright and fades it in.
    func setModel(_ entity: Entity) {
        guard !isTornDown, let anchorEntity else { return }
        model = entity
        // Stand the model upright relative to the image (see correction note above),
        // composing with any authored orientation rather than discarding it.
        entity.orientation = Self.modelOrientationCorrection * entity.orientation
        // Loop any authored animations so the model is alive while in view; the
        // controllers are paused/resumed alongside the video in `setTracked`.
        modelAnimations = entity.availableAnimations.map { entity.playAnimation($0.repeat()) }
        // Start fully transparent (set before attaching to avoid a one-frame pop)
        // and dissolve in instead of appearing instantly when the download lands.
        entity.components.set(OpacityComponent(opacity: 0))
        anchorEntity.addChild(entity)
        fadeInModel(entity)
    }

    /// Dissolves the model from transparent to opaque so it eases into place
    /// instead of appearing instantly. `OpacityComponent` is hierarchical, so
    /// binding the animation to `.opacity` fades the whole model as one.
    private func fadeInModel(_ entity: Entity, duration: TimeInterval = 0.6) {
        let fade = FromToByAnimation(
            from: Float(0),
            to: Float(1),
            duration: duration,
            timing: .easeOut,
            bindTarget: .opacity
        )
        if let animation = try? AnimationResource.generate(with: fade) {
            entity.playAnimation(animation)
        }
    }

    /// Drives both overlays off the image's tracking state. While the image is
    /// in view the video and model animations run; when tracking is lost they
    /// pause and the model hides so a stale object doesn't float in space.
    func setTracked(_ isTracked: Bool) {
        guard !isTornDown else { return }
        if isTracked {
            player?.play()
            modelAnimations.forEach { $0.resume() }
        } else {
            player?.pause()
            modelAnimations.forEach { $0.pause() }
        }
        model?.isEnabled = isTracked
    }

    func teardown() {
        isTornDown = true
        player?.pause()
        looper = nil
        player = nil
        modelAnimations.forEach { $0.stop() }
        modelAnimations = []
        model = nil
        anchorEntity?.removeFromParent()
        anchorEntity = nil
    }
}
