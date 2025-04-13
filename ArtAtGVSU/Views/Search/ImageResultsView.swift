//
//  ImageResultsView.swift
//  ArtAtGVSU
//
//  Created by Francis Corona on 3/16/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//


// Display the captured image.
// Show 5-10 related images based on the captured image.

import SwiftUI

struct ImageResultsView: View {
    // The image that was captured and will be displayed at the top
    var image: UIImage? = nil

    // State variable to store the images returned from the query
    @State private var relatedImages: [UIImage] = []

    // Tracks whether the images are still loading
    @State private var isLoading = true

    // Layout definition for the grid of related images (2 columns)
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            // Set background color
            Color(UIColor.systemBackground).ignoresSafeArea()

            ScrollView {
                VStack {
                    // Display the captured image
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: UIScreen.main.bounds.height / 2)
                            .clipped()
                            .cornerRadius(15)
                    }

                    // Title for the related images section
                    Text("Related Images")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)

                    // Show a loading spinner while images are loading
                    if isLoading {
                        ProgressView("Loading images...")
                            .padding()
                    }

                    // Display the grid of related images
                    LazyVGrid(columns: columns, spacing: 10) {
                        // Show a fallback message if no results were found
                        if relatedImages.isEmpty && !isLoading {
                            Text("No related images found.")
                                .foregroundColor(.gray)
                                .padding()
                        }

                        // Loop through and show each related image
                        ForEach(relatedImages.indices, id: \.self) { index in
                            Image(uiImage: relatedImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 100)
                                .cornerRadius(8)
                                .clipped()
                        }
                    }
                    .padding()
                }
            }
        }
        // Trigger image search when view appears
        .onAppear(perform: loadImages)
        .navigationTitle("AI Image Search")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Loads related images by sending the captured image to the backend
    func loadImages() {
        guard let img = image else {
            print("No image to send to /query.")
            self.isLoading = false
            return
        }

        NetworkManager.shared.sendImageToQueryEndpoint(img) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imgs):
                    print("Received \(imgs.count) images")
                    self.relatedImages = imgs
                case .failure(let error):
                    print("Failed to load images: \(error.localizedDescription)")
                }
                self.isLoading = false
            }
        }
    }
}
