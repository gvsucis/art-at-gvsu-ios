//
//  FeaturedIndexView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 7/10/24.
//  Copyright © 2024 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct FeaturedIndexView: View {
    let collection: ArtworkCollection
    @State var data: Async<[Artwork]> = .uninitialized
    @State private var isPresentingAR = false

    var body: some View {
        VStack {
            switch data {
            case .success(let artworks):
                FeaturedIndexLoadedView(artworks: artworks)
            case .loading:
                LoadingView()
            default:
                EmptyView()
            }
        }
        .onAppear(perform: fetchArtworks)
        .background(Color.background)
        .navigationTitle(LocalizedStringKey(title))
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            if collection == .featuredAR {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isPresentingAR = true }) {
                        Image(systemName: "camera.viewfinder")
                    }
                    .accessibilityLabel("View in augmented reality")
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentingAR) {
            ARExperienceView()
        }
    }

    private func fetchArtworks() {
        if data.isLoading || data.isSuccess { return }

        data = .loading
        Artwork.search(term: collection.slug) { artworks in
            data = .success(artworks)
        }
    }

    private var title: String {
        switch collection {
        case .featuredArt:
            "featuredIndex_ArtNavigationTitle"
        default:
            "featuredIndex_ARNavigationTitle"
        }
    }
}

#Preview {
    FeaturedIndexView(collection: .featuredAR)
}
