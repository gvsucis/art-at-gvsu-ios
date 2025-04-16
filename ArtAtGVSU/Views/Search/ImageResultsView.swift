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
    var image: UIImage? = nil

    @State private var relatedArtworks: [Artwork] = []
    @State private var isLoading = true

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()

            ScrollView {
                VStack {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: UIScreen.main.bounds.height / 2.5)
                            .clipped()
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }

                    Text("Related Artwork")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 10)

                    if isLoading {
                        ProgressView("Loading artworks...")
                            .padding()
                    } else if relatedArtworks.isEmpty {
                        Text("No related artworks found.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(relatedArtworks, id: \.id) { artwork in
                                NavigationLink(destination: ArtworkDetailRepresentable(artworkID: artwork.id)) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        AsyncImage(url: artwork.thumbnail) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                        }
                                        .frame(width: 160, height: 120)
                                        .cornerRadius(8)
                                        .clipped()

                                        Text(artwork.name)
                                            .font(.caption)
                                            .lineLimit(1)
                                            .frame(width: 160, alignment: .leading)

                                        Text(artwork.artistName)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                            .frame(width: 160, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear(perform: loadImages)
        .navigationTitle("AI Image Search")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadImages() {
        guard let img = image else {
            print("No image to send to /query.")
            self.isLoading = false
            return
        }

        NetworkManager.shared.sendImageToQueryEndpoint(img) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ids):
                    Artwork.fetchMany(ids: ids) { artworks in
                        self.relatedArtworks = artworks
                        self.isLoading = false
                    }
                case .failure(let error):
                    print("Failed to fetch related artworks: \(error)")
                    self.relatedArtworks = []
                    self.isLoading = false
                }
            }
        }
    }
}
