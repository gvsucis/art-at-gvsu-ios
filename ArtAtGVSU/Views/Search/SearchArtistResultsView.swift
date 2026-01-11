//
//  SearchArtistResultsView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 1/11/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct SearchArtistResultsView: View {
    let query: String
    @State private var results: Async<[Artist]> = .uninitialized

    var body: some View {
        VStack {
            switch results {
            case .success(let artists):
                if artists.isEmpty {
                    Text("search_noResultsFound")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(artists, id: \.id) { artist in
                        NavigationLink(destination: ArtistDetailView(id: artist.id)) {
                            SearchArtistListItem(artist: artist)
                        }
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
        .navigationTitle(translate("search_filter_Artists"))
        .onAppear(perform: fetchResults)
    }

    private func fetchResults() {
        guard !results.isSuccess else { return }
        results = .loading
        Artist.search(term: query) { artists in
            results = .success(artists)
        }
    }
}

private struct SearchArtistListItem: View {
    let artist: Artist

    var body: some View {
        VStack(alignment: .leading) {
            Text(artist.name)
                .foregroundColor(Color(UIColor.label))
            if !artist.lifeDatesSummary.isEmpty {
                Text(artist.lifeDatesSummary)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .font(.subheadline)
            }
        }
    }
}

struct SearchArtistResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchArtistResultsView(query: "alten")
        }
    }
}
