//
//  Favorite.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

struct Favorite {
    var artworkID: String
    var artworkName: String
    var imageURL: String
    var artistName: String    
}

class FavoritesStore: ObservableObject {
    @Published var isFavorite = false

    var artworkID: String {
        didSet {
            isFavorite = getFavorite()
        }
    }
    var artwork: Artwork? {
        didSet {
            if artwork != nil {
                artworkID = artwork!.id
            }
        }
    }

    init(artworkID: String) {
        self.artworkID = artworkID
    }

    func toggle() {
        setFavorite()
        isFavorite = getFavorite()
    }

    func getFavorite() -> Bool {
        if let favorites = UserDefaults.standard.object(forKey: "favoritesDict") as? [String : [String:String]] {
            return favorites.keys.contains(artworkID)
        } else {
            UserDefaults.standard.set([], forKey: "favoritesDict")
            return false
        }
    }

    func setFavorite() {
        guard let artwork = artwork else { return }

        var favorites = FavoritesStore.findFavoritesStore()

        if favorites.keys.contains(artwork.id) {
            favorites.removeValue(forKey: artwork.id)
        } else {
            let imageURL = artwork.mediaMedium?.absoluteString ?? ""
            
            let values = [
                "id": artwork.id,
                "artworkName":artwork.name,
                "url": imageURL,
                "artistName": artwork.artistName
            ]

            favorites[artwork.id] = values
        }

        UserDefaults.standard.set(favorites, forKey: "favoritesDict")
    }

    static func favorites() -> [Favorite] {
        return findFavoritesStore().values.map { artwork in
            return Favorite(
                artworkID: artwork["id"] ?? "",
                artworkName: artwork["artworkName"] ?? "",
                imageURL: artwork["url"] ?? "",
                artistName: artwork["artistName"] ?? ""
            )
        }
    }

    private static func findFavoritesStore() -> [String: [String:String]] {
        if let favorites = UserDefaults.standard.object(forKey: "favoritesDict") as? [String : [String:String]] {
            return favorites
        } else {
            return [:]
        }
    }
}
