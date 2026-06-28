//
//  VisionCameraButton.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/26/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct VisionCameraButton: View {
  @State private var isPresentingCamera = false
  @State var showVisionResult: Bool = false
  @State var capturedImage: UIImage? = nil

  var body: some View {
      Button(action: {
          isPresentingCamera = true
      }) {
          Image(systemName: "camera")
      }
      .fullScreenCover(isPresented: $isPresentingCamera) {
          VisionSearchCamera(capturedImage: $capturedImage)
              .onDisappear {
                  if capturedImage != nil {
                      showVisionResult = true
                  }
              }
      }
      .navigationDestination(isPresented: $showVisionResult) {
          VisionResultView(capturedImage: capturedImage)
              .navigationBarTitleDisplayMode(.inline)
              .navigationTitle("navigation_SimilarWorks")
      }
  }
}
