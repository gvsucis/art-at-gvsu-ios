//
//  VisionCameraButton.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/26/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import UIKit

struct VisionCameraButton: View {
  @State private var isPresentingCamera = false
  @State var showVisionResult: Bool = false
  @State var capturedImage: UIImage? = nil

  var body: some View {
      ZStack {
          NavigationLink(
              destination: VisionResultView(capturedImage: capturedImage)
                  .navigationBarTitleDisplayMode(.inline)
                  .navigationTitle("navigation_SimilarWorks"),
              isActive: $showVisionResult
          ) {
              EmptyView()
          }
          Button(action: {
            isPresentingCamera = true
          }) {
            Image(systemName: "camera")
          }.fullScreenCover(isPresented: $isPresentingCamera) {
              CameraView(capturedImage: $capturedImage)
                  .onDisappear {
                      if capturedImage != nil {
                          showVisionResult = true
                      }
                  }
          }
      }
  }
}

struct CameraView: UIViewControllerRepresentable {
  @Binding var capturedImage: UIImage?

  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var parent: CameraView

    init(parent: CameraView) {
      self.parent = parent
    }

    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      if let image = info[.originalImage] as? UIImage {
        parent.capturedImage = image
      }
      picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true)
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    picker.sourceType = .camera
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct VisionCameraButton_Previews: PreviewProvider {
  static var previews: some View {
    VisionCameraButton()
  }
}
