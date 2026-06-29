//
//  ARExperienceModel.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/19/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import Foundation
import ARKit
import AVFoundation
import UIKit

/// Loads the gallery's AR set, resolves device/permission prerequisites, and
/// builds the `ARReferenceImage` set the session tracks against.
@MainActor
final class ARExperienceModel: ObservableObject, Logging {
    enum State {
        case loading
        case ready(referenceImages: Set<ARReferenceImage>, artworksByImageName: [String: Artwork])
        case unsupported
        case cameraDenied
        case empty
        case failed
    }

    @Published private(set) var state: State = .loading

    /// Pixels-to-meters at 96 dpi. The `simple` search API doesn't expose real
    /// artwork dimensions, so we approximate the printed width from the image.
    private static let pixelsToMeters = 0.0002645833

    func load() async {
        guard ARWorldTrackingConfiguration.isSupported else {
            state = .unsupported
            return
        }
        guard await ensureCameraAccess() else {
            state = .cameraDenied
            return
        }

        let artworks = await Artwork.fetchARArtworks()
        guard !artworks.isEmpty else {
            state = .empty
            return
        }

        var referenceImages = Set<ARReferenceImage>()
        var artworksByImageName: [String: Artwork] = [:]

        await withTaskGroup(of: (Artwork, ARReferenceImage?).self) { group in
            for artwork in artworks {
                group.addTask { (artwork, await Self.makeReferenceImage(for: artwork)) }
            }
            for await (artwork, referenceImage) in group {
                guard let referenceImage else { continue }
                referenceImages.insert(referenceImage)
                artworksByImageName[artwork.id] = artwork
            }
        }

        guard !referenceImages.isEmpty else {
            state = .failed
            return
        }

        state = .ready(referenceImages: referenceImages, artworksByImageName: artworksByImageName)
    }

    private func ensureCameraAccess() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        default:
            return false
        }
    }

    private static func makeReferenceImage(for artwork: Artwork) async -> ARReferenceImage? {
        guard let imageURL = artwork.mediaMedium else { return nil }
        do {
            let data = try await ARMediaCache.shared.data(for: imageURL)
            guard let cgImage = UIImage(data: data)?.cgImage else { return nil }

            let physicalWidth = CGFloat(cgImage.width) * pixelsToMeters
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: physicalWidth)
            referenceImage.name = artwork.id
            return referenceImage
        } catch {
            return nil
        }
    }
}
