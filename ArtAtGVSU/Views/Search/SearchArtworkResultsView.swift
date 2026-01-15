//
//  SearchArtworkResultsView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 1/11/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct SearchArtworkResultsView: View {
    let query: String
    @State private var results: Async<[Artwork]> = .uninitialized

    var body: some View {
        VStack {
            switch results {
            case .success(let artworks):
                if artworks.isEmpty {
                    Text("search_noResultsFound")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(artworks, id: \.id) { artwork in
                        ArtworkDetailNavigationLink(artwork: artwork)
                            .listRowBackground(Color.background)
                    }
                    .listStyle(PlainListStyle())
                }
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            default:
                EmptyView()
            }
        }
        .navigationTitle(translate("search_filter_Artworks"))
        .onAppear(perform: fetchResults)
    }

    private func fetchResults() {
        guard !results.isSuccess else { return }
        results = .loading
        Artwork.search(term: query) { artworks in
            results = .success(artworks)
        }
    }
}

struct SearchArtworkResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchArtworkResultsView(query: "landscape")
        }
    }
}
