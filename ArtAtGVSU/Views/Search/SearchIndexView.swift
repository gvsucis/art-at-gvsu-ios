//
//  SearchIndex.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/1/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct SearchIndexView: View {
    @StateObject var viewModel = SearchIndexModel()

    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }

    var body: some View {
        VStack {
            switch viewModel.results {
            case .success(let searchResults):
                SearchIndexLoadedView(searchResults: searchResults, query: viewModel.query)
            case .loading:
                ProgressView()
            default:
                SearchIndexEmptyView()
            }
        }
        .searchable(text: $viewModel.query)
    }
}

struct SearchIndexLoadedView: View {
    var searchResults: UnifiedSearchResults
    var query: String

    var body: some View {
        VStack {
            if !query.isEmpty && !searchResults.isEmpty {
                SearchIndexResultsView(searchResults: searchResults, query: query)
            } else if !query.isEmpty {
                SearchIndexNoResultsView()
            } else {
                SearchIndexEmptyView()
            }
        }
    }
}

struct SearchIndexResultsView: View {
    var searchResults: UnifiedSearchResults
    var query: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if !searchResults.artworksPreview.isEmpty {
                    SearchResultSection(
                        title: translate("search_filter_Artworks"),
                        showSeeMore: searchResults.hasMoreArtworks
                    ) {
                        SearchArtworkResultsView(query: query)
                    } content: {
                        SearchArtworksRow(artworks: searchResults.artworksPreview)
                    }
                }

                if !searchResults.artistsPreview.isEmpty {
                    SearchResultSection(
                        title: translate("search_filter_Artists"),
                        showSeeMore: searchResults.hasMoreArtists
                    ) {
                        SearchArtistResultsView(query: query)
                    } content: {
                        SearchArtistsRow(artists: searchResults.artistsPreview)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

struct SearchResultSection<Destination: View, Content: View>: View {
    let title: String
    let showSeeMore: Bool
    let destination: () -> Destination
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                if showSeeMore {
                    NavigationLink(destination: destination()) {
                        Text("search_seeMore")
                            .font(.subheadline)
                    }
                }
            }
            .padding(.horizontal)

            content()
        }
    }
}

struct SearchArtworksRow: View {
    let artworks: [Artwork]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(artworks, id: \.id) { artwork in
                    Button(action: {
                        ArtworkDetailController.present(artworkID: artwork.id)
                    }) {
                        SearchResultCard(
                            title: artwork.name,
                            subtitle: artwork.artistName,
                            imageURL: artwork.thumbnail
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SearchArtistsRow: View {
    let artists: [Artist]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(artists, id: \.id) { artist in
                    NavigationLink(destination: ArtistDetailView(id: artist.id)) {
                        SearchArtistCard(
                            name: artist.name,
                            lifeDates: artist.lifeDatesSummary,
                            imageURL: artist.relatedWorks.first?.thumbnail
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SearchIndexNoResultsView: View {
    var body: some View {
        VStack {
            Text("search_noResultsFound")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SearchIndexEmptyView: View {
    var body: some View {
        VStack {
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SearchIndexView_Previews: PreviewProvider {
    static var previews: some View {
        SearchIndexView()
    }
}
