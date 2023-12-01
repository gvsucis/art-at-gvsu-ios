//
//  SearchIndexModel.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/1/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import Combine

let ARTISTS = 0
let ARTWORKS = 1

class SearchIndexModel: ObservableObject {
    @Published var results: Async<[SearchResult]> = .uninitialized
    let subject = PassthroughSubject<SearchValue, Never>()
    var subscription: Cancellable?
    let transport = URLSession(configuration: .default)

    init() {
    }

    func search(query: String, category: Int) {
        initSubscription()
        subject.send(SearchValue(term: query, category: category))
    }

    private func delayedSearch(_ value: SearchValue) {
        transport.cancelAll()
        if value.term == "" {
            results = .uninitialized
            return
        }
        results = .loading
        switch value.category {
        case ARTISTS:
            Artist.search(term: value.term, transport: transport) { artists in
                self.results = .success(artists.map { SearchResult.artist($0) })
            }
        default:
            Artwork.search(term: value.term, transport: transport) { artists in
                self.results = .success(artists.map { SearchResult.artwork($0) })
            }
        }
    }

    private func initSubscription() {
        guard subscription == nil else { return }
        subscription = subject
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { value in
                self.delayedSearch(value)
            }
    }
}

struct SearchValue {
    var term: String
    var category: Int
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
