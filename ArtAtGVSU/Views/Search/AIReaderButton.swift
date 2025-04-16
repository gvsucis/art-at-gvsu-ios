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
    // Controls whether the full-screen camera modal is shown
    @State private var showModal = false
    
    // Stores the image captured by the AIReader camera
    @State private var selectedImage: UIImage? = nil
    
    // Controls navigation to the ImageResultsView after image capture
    @State private var navigateToResults = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Hidden navigation link that becomes active when an image is selected
                NavigationLink(
                    destination: ImageResultsView(image: selectedImage),
                    isActive: $navigateToResults
                ) {
                    EmptyView()
                }
                .hidden() // Keep the link invisible, only used for programmatic navigation

                // Button with a "sparkles" system icon to launch the camera
                Button(action: openModal) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 15))
                        .padding(6)
                }
                .fullScreenCover(isPresented: $showModal) {
                    // Launches the AIReader camera view modally
                    AIReader(
                        onImageCaptured: { image in selectImage(image) },
                        onClose: closeModal
                    )
                }
            }
        }
    }

    // Handles the image selected from the AIReader and prepares for navigation
    func selectImage(_ image: UIImage) {
        self.selectedImage = image
        self.showModal = false
        
        // Add a slight delay before navigating to give the modal time to dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigateToResults = true
        }
    }

    // Opens the full-screen AIReader modal
    func openModal() { showModal = true }
    
    // Closes the full-screen AIReader modal
    func closeModal() { showModal = false }
}
