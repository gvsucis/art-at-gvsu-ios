//
//  ArtworkDetail.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/2/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//
import SwiftUI
import Combine
import os

class ArtworkDetailModel: ObservableObject {
    var artworkID: String
    var delegate: ArtworkDetailDelegate
    @Published var artwork: Artwork?
    @Published var index = 0
    @ObservedObject var favorite: FavoritesStore

    init(delegate: ArtworkDetailDelegate, artworkID: String) {
        self.delegate = delegate
        self.artworkID = artworkID
        self.favorite = FavoritesStore(artworkID: artworkID)
    }

    func fetchArtwork() {
        Artwork.fetch(id: artworkID) { artwork, error in
            if let error = error {
                Logger().error("\(error.localizedDescription)")
                return
            }
            if let artwork = artwork {
                self.artwork = artwork
                self.favorite.artwork = artwork
            }
        }
    }

    var urlCount: Int {
        artwork!.mediaRepresentations.count
    }
}


protocol ArtworkDetailDelegate {
    func presentImageViewer()
    func presentImageViewer(url: URL)
    func presentArtworkDetail(artworkID: String)
}
