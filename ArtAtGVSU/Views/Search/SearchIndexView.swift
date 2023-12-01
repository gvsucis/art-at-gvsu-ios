//
//  SearchIndex.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/1/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct SearchIndexView: View {
    let filters = [
        translate("search_filter_Artists"),
        translate("search_filter_Artworks")
    ]

    @State var query = ""
    @State var filterIndex = 0
    @ObservedObject var viewModel = SearchIndexModel()

    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }

    var body: some View {
        VStack {
            switch viewModel.results {
            case .success(let searchResults):
                SearchIndexLoadedView(searchResults: searchResults, query: query)
            case .loading:
                LoadingView()
            default:
                SearchIndexEmptyView()
            }
        }
        .background(Color.background)
        .navigationBarSearch(
            $query,
            selectedScopeButtonIndex: $filterIndex,
            scopeButtonTitles: filters,
            placeholder: translate("search_Placeholder"),
            hidesSearchBarWhenScrolling: false
        )
        .onChange(of: filterIndex, perform: { f in
            viewModel.search(query: query, category: f)
        })
        .onChange(of: query, perform: { q in
            viewModel.search(query: q, category: filterIndex)
        })
    }
}

struct SearchIndexLoadedView: View {
    var searchResults: [SearchResult]
    var query: String

    var body: some View {
        VStack {
            if query != "" && searchResults.count > 0 {
                SearchIndexListView(searchResults: searchResults)
            } else if query != "" {
                SearchIndexNoResultsView()
            } else {
                SearchIndexEmptyView()
            }
        }
    }
}


struct SearchIndexListView: View {
    var searchResults: [SearchResult]

    var body: some View {
        List(searchResults) { searchResult in
            HStack {
                switch searchResult {
                case .artist(let artist):
                    SearchIndexArtistListItem(artist: artist)
                case .artwork(let artwork):
                    SearchIndexArtworkListItem(artwork: artwork)
                }
            }
        }
    }
}

struct SearchIndexArtistListItem: View {
    var artist: Artist

    var body: some View {
        NavigationLink(destination: ArtistDetailView(id: artist.id)) {
            SearchIndexListItem(title: artist.name, subtitle: artist.lifeDatesSummary)
        }
    }
}

struct SearchIndexArtworkListItem: View {
    var artwork: Artwork

    var body: some View {
        NavigationLink(destination: ArtworkDetailRepresentable(artworkID: artwork.id)) {
            SearchIndexListItem(title: artwork.name, subtitle: artwork.artistName)
        }
    }
}

struct SearchIndexListItem: View {
    var title: String
    var subtitle: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(Color(UIColor.label))
            if subtitle != "" {
                Text(subtitle)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .font(.subheadline)
            }
        }
    }
}

struct SearchIndexNoResultsView: View {
    var body: some View {
        VStack {
            Text("search_noResultsFound")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

struct SearchIndexEmptyView: View {
    var body: some View {
        VStack {
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

struct SearchIndexView_Previews: PreviewProvider {
    static var previews: some View {
        SearchIndexView()
    }
}
