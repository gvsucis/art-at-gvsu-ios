//
//  SearchIndexModel.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/1/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import Combine

enum SearchScope: Equatable {
    case artists
    case artworks
}

class SearchIndexModel: ObservableObject {
    @Published var results: Async<[SearchResult]> = .uninitialized
    @Published var scope: SearchScope = .artworks
    @Published var query: String = ""
    let transport = URLSession(configuration: .default)
    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest($query, $scope)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates { $0.0 == $1.0 && $0.1 == $1.1 } // Skip search if query and scope haven't changed
            .sink { [weak self] _ in
                self?.search()
            }
            .store(in: &cancellables)
    }

    func search() {
        transport.cancelAll()
        if query == "" {
            results = .uninitialized
            return
        }
        results = .loading
        switch scope {
        case .artists:
            Artist.search(term: query, transport: transport) { artists in
                self.results = .success(artists.map { SearchResult.artist($0) })
            }
        default:
            Artwork.search(term: query, transport: transport) { artists in
                self.results = .success(artists.map { SearchResult.artwork($0) })
            }
        }
    }
}

enum SearchResult: Identifiable {
    case artist(Artist)
    case artwork(Artwork)

    var id: String {
        switch self {
        case .artist(let artist):
            return "artist:\(artist.id)"
        case .artwork(let artwork):
            return "artwork:\(artwork.id)"
        }
    }
}
