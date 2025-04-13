//
//  CameraScreen.swift
//  ArtAtGVSU
//
//  Created by Francis Corona on 4/11/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import UIKit

struct CameraScreen: View {
    // State variable to store the image captured by the camera
    @State private var image: UIImage? = nil
    
    // State variable to control navigation to the results screen
    @State private var navigateToResults = false

    var body: some View {
        VStack {
            // If no image has been captured yet, show the camera view
            if image == nil {
                CameraView(image: $image)
                    .edgesIgnoringSafeArea(.all) // Use full screen for the camera
            } else {
                // Show a loading indicator while the image is being uploaded
                ProgressView("Uploading Image...")
                    .onAppear {
                        uploadImage()
                    }
            }

            // Hidden navigation link that becomes active after image upload
            NavigationLink(
                destination: ImageResultsView(image: image),
                isActive: $navigateToResults
            ) {
                EmptyView() // No visible content, it's just a trigger
            }
        }
    }

    /// Uploads the captured image to the backend query endpoint
    func uploadImage() {
        guard let img = image else { return }

        // Send the image to the backend
        NetworkManager.shared.sendImageToQueryEndpoint(img) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    // If successful, trigger navigation to results view
                    navigateToResults = true
                case .failure(let error):
                    // If failed, print error and reset image to allow retry
                    print("Failed to upload image: \(error.localizedDescription)")
                    image = nil
                }
            }
        }
    }
}
