//
//  VisionSearchCamera.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 7/21/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

struct VisionSearchCamera: View {
  @StateObject private var cameraManager = CameraManager()
  @Binding var capturedImage: UIImage?
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      VStack(spacing: 0) {
        GeometryReader { geometry in
          let sideLength = min(geometry.size.width, geometry.size.height)

          CameraPreview(session: cameraManager.session)
            .aspectRatio(1, contentMode: .fill)
            .frame(width: sideLength, height: sideLength)
            .clipped()
            .cornerRadius(12)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .frame(maxHeight: .infinity)

        VStack(spacing: 32) {
          Text("vision_search_call_to_action")
            .font(.title2)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)

          Button(action: {
            cameraManager.capturePhoto { image in
              capturedImage = image
              presentationMode.wrappedValue.dismiss()
            }
          }) {
            Circle()
              .fill(Color.white)
              .frame(width: 80, height: 80)
              .overlay(
                Circle()
                  .stroke(Color.black, lineWidth: 2)
                  .frame(width: 70, height: 70)
              )
          }
        }
        .padding(.bottom, 50)
      }

      VStack {
        HStack {
          Button("vision_search_cancel") {
            presentationMode.wrappedValue.dismiss()
          }
          .foregroundColor(.white)
          .padding()

          Spacer()
        }

        Spacer()
      }
    }
    .onDisappear {
      cameraManager.stopSession()
    }
  }
}

class VideoPreviewView: UIView {
  override class var layerClass: AnyClass {
    AVCaptureVideoPreviewLayer.self
  }

  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    return layer as! AVCaptureVideoPreviewLayer
  }
}

struct CameraPreview: UIViewRepresentable {
  let session: AVCaptureSession

  func makeUIView(context: Context) -> VideoPreviewView {
    let view = VideoPreviewView()
    view.backgroundColor = .black
    view.videoPreviewLayer.session = session
    view.videoPreviewLayer.videoGravity = .resizeAspectFill
    if let connection = view.videoPreviewLayer.connection {
      connection.videoRotationAngle = 90
    }
    return view
  }

  func updateUIView(_ uiView: VideoPreviewView, context: Context) { }
}

class CameraManager: NSObject, ObservableObject {
  @Published var capturedImage: UIImage?
  let session = AVCaptureSession()
  private let photoOutput = AVCapturePhotoOutput()
  private var captureCompletion: ((UIImage?) -> Void)?

  override init() {
    super.init()
    configureSession()
  }

  private func configureSession() {
    guard let camera = AVCaptureDevice.default(for: .video) else { return }

    do {
      let input = try AVCaptureDeviceInput(device: camera)

      if session.canAddInput(input) {
        session.addInput(input)
      }

      if session.canAddOutput(photoOutput) {
        session.addOutput(photoOutput)
      }

      session.sessionPreset = .photo

      DispatchQueue.global(qos: .userInitiated).async {
        self.session.startRunning()
      }
    } catch {
      print("Error setting up camera: \(error)")
    }
  }

  func capturePhoto(completion: @escaping (UIImage?) -> Void) {
    captureCompletion = completion

    let settings = AVCapturePhotoSettings()
    photoOutput.capturePhoto(with: settings, delegate: self)
  }

  func stopSession() {
    session.stopRunning()
  }
}


extension CameraManager: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard let imageData = photo.fileDataRepresentation(),
          let image = UIImage(data: imageData) else {
      captureCompletion?(nil)
      return
    }

    let squareImage = cropImageToSquare(image)
    capturedImage = squareImage
    captureCompletion?(squareImage)
  }

  private func cropImageToSquare(_ image: UIImage) -> UIImage {
    let originalSize = image.size
    let sideLength = min(originalSize.width, originalSize.height)

    let xOffset = (originalSize.width - sideLength) / 2
    let yOffset = (originalSize.height - sideLength) / 2

    let cropRect = CGRect(x: xOffset, y: yOffset, width: sideLength, height: sideLength)

    guard let cgImage = image.cgImage?.cropping(to: cropRect) else {
      return image
    }

    return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
  }
}
