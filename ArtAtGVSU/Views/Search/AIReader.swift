//
//  AIReader.swift
//  ArtAtGVSU
//
//  Created by Francis Corona on 3/16/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//
//

import SwiftUI
import AVFoundation
import UIKit

// SwiftUI view that presents a camera interface for capturing an image.
// Uses a callback function to pass the captured image to the parent view and includes a close button.

struct AIReader: View {
    var onImageCaptured: (UIImage) -> Void  // Callback when an image is captured
    var onClose: () -> Void  // Callback when the user closes the view

    @State private var capturedImage: UIImage? = nil  // Holds the captured image

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Full screen camera view
            CameraView(image: $capturedImage)  // Use a Binding<UIImage?> instead of a closure
                .ignoresSafeArea()
                .onChange(of: capturedImage) { newImage in
                    if let newImage = newImage {
                        confirmImage(image: newImage)
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // Confirms the selected image and passes it to the callback function
    func confirmImage(image: UIImage) {
        onImageCaptured(image)
        onClose() // Close the camera view immediately after capturing an image
    }
}
