//
//  ARExperienceView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/19/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import SwiftUI

/// Full-screen roaming AR experience: point the camera at any AR artwork in the
/// gallery and its video plays in place.
struct ARExperienceView: View {
    @StateObject private var model = ARExperienceModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            content

            VStack {
                HStack {
                    Spacer()
                    closeButton
                }
                Spacer()
            }
            .padding()
        }
        .task { await model.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch model.state {
        case .loading:
            ProgressView()
                .tint(.white)
        case let .ready(referenceImages, artworksByImageName):
            ZStack {
                ARViewContainer(
                    referenceImages: referenceImages,
                    artworksByImageName: artworksByImageName
                )
                .ignoresSafeArea()

                VStack {
                    Spacer()
                    hint
                }
            }
        case .unsupported:
            message("Augmented reality isn't supported on this device.")
        case .cameraDenied:
            VStack(spacing: 16) {
                message("Camera access is needed to view artwork in augmented reality.")
                settingsButton
            }
        case .empty:
            message("There's no AR artwork available right now.")
        case .failed:
            message("Something went wrong loading AR artwork. Please try again.")
        }
    }

    private var closeButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "xmark")
                .font(.title2)
                .foregroundColor(.white)
                .padding(8)
        }
        .accessibilityLabel("Close")
    }

    private var hint: some View {
        Text("Point your camera at the artwork and watch it come alive!")
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
    }

    private func message(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(32)
    }

    private var settingsButton: some View {
        Button("Open Settings") {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}
