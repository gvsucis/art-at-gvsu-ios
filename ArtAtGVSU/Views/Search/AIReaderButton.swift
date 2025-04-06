//
//  AIReaderButton.swift
//  ArtAtGVSU
//
//  Created by Francis Corona on 3/16/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

// A SwiftUI button that opens an AI-powered camera interface, captures an image, and navigates to a results view.

import SwiftUI

struct AIReaderButton: View {
    @State private var showModal = false
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToResults = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Navigation link that activates when an image is captured
                NavigationLink(
                    destination: ImageResultsView(image: selectedImage),
                    isActive: $navigateToResults
                ) {
                    EmptyView()
                }
                .hidden()

                // AI Button to open the camera
                Button(action: openModal) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 15))
                        .padding(6)
                }
                .fullScreenCover(isPresented: $showModal) {
                    AIReader(
                        onImageCaptured: { image in selectImage(image) },
                        onClose: closeModal
                    )
                }
            }
        }
    }

    func selectImage(_ image: UIImage) {
        self.selectedImage = image
        self.showModal = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigateToResults = true // ✅ Ensure navigation happens after image is captured
        }
    }

    func openModal() { showModal = true }
    func closeModal() { showModal = false }
}
