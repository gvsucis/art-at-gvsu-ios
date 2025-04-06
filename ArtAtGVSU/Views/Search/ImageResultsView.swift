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
    var image: UIImage?

    let columns = [GridItem(.flexible()), GridItem(.flexible())] // Two-column grid

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            ScrollView {
                VStack {
                    // Image Display
                    if let image = image {
                        TabView {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()  // Ensures the image fills the space
                                .frame(height: UIScreen.main.bounds.height / 2) // Takes half of the screen
                                .clipped()
                                .cornerRadius(15) // Rounded corners
                                .tag(0)
                        }
                        .frame(height: UIScreen.main.bounds.height / 2)
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle())

                        // Bold Title under Image
                        Text("Related Images")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                            .padding(.horizontal)
                    } else {
                        Rectangle()
                            .fill(Color(UIColor.systemGray2))
                            .frame(height: UIScreen.main.bounds.height / 2)
                            .cornerRadius(15) // Rounded corners for placeholder
                            .aspectRatio(contentMode: .fill)

                        ProgressView()
                            .padding()
                    }

                    // Grid Container for Related Images (Currently Empty)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<10, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 100)
                                .cornerRadius(8) // Rounded corners for grid items
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("AI Image Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ImageResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ImageResultsView(image: UIImage(systemName: "photo"))
    }
}
