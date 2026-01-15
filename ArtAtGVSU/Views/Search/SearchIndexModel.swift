//
//  SearchIndexModel.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/1/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import Combine

private let previewLimit = 11

struct UnifiedSearchResults {
    let artworks: [Artwork]
    let artists: [Artist]

    var artworksPreview: [Artwork] {
        Array(artworks.prefix(10))
    }

    var artistsPreview: [Artist] {
        Array(artists.prefix(10))
    }

    var hasMoreArtworks: Bool {
        artworks.count > 10
    }

    var hasMoreArtists: Bool {
        artists.count > 10
    }

    var isEmpty: Bool {
        artworks.isEmpty && artists.isEmpty
    }
}

class SearchIndexModel: ObservableObject {
    @Published var results: Async<UnifiedSearchResults> = .uninitialized
    @Published var query: String = ""
    let transport = URLSession(configuration: .default)
    private var cancellables = Set<AnyCancellable>()

    init() {
        $query
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.search()
            }
            .store(in: &cancellables)
    }

    func search() {
        transport.cancelAll()
        if query.isEmpty {
            results = .uninitialized
            return
        }
        results = .loading

        let group = DispatchGroup()
        var fetchedArtworks: [Artwork] = []
        var fetchedArtists: [Artist] = []

        group.enter()
        Artwork.search(term: query, limit: previewLimit, transport: transport) { artworks in
            fetchedArtworks = artworks
            group.leave()
        }

        group.enter()
        Artist.search(term: query, limit: previewLimit, transport: transport) { artists in
            fetchedArtists = artists
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.results = .success(UnifiedSearchResults(
                artworks: fetchedArtworks,
                artists: fetchedArtists
            ))
        }
    }
}
