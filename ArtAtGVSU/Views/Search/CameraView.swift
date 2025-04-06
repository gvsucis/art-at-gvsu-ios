//
//  CameraView.swift
//  ArtAtGVSU
//
//  Created by Francis Corona on 3/16/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import UIKit

// Handles camera using UIImagePickerController.
// User can take a photo and pass it back to the parent view.

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?  // Binding to store the captured image

    // Creates a coordinator to handle camera actions.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Creates and configures the UIImagePickerController (camera).
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera  // Set camera as the source
        picker.delegate = context.coordinator  // Assign delegate to handle image selection
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // Coordinator class to handle image selection and dismissal.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        // Called when an image is picked. Updates the bound image.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image  // Save the selected image
            }
            picker.dismiss(animated: true)  // Close the camera view
        }

        // Called when the user cancels image selection.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)  // Close the camera view without saving an image
        }
    }
}
