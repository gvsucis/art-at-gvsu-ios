//
//  Favorite.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

struct Favorite: Identifiable, Comparable {
    var artworkID: String
    var artworkName: String
    var imageURL: URL?
    var artistName: String
    
    var id: String {
        return artworkID
    }
    
    static func < (lhs: Favorite, rhs: Favorite) -> Bool {
        return lhs.id < rhs.id
    }
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
        if let favorites = UserDefaults.standard.object(forKey: favoritesKey) as? Favorites {
            return favorites.keys.contains(artworkID)
        } else {
            let emptyFavorites:  [String: [String: String]] = [:]
            UserDefaults.standard.set(emptyFavorites, forKey: favoritesKey)
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

        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }

    static func favorites() -> [Favorite] {
        return mapFavorites(findFavoritesStore()).sorted()
    }

    private static func findFavoritesStore() -> Favorites {
        if let favorites = UserDefaults.standard.object(forKey: favoritesKey) as? Favorites {
            return favorites
        } else {
            return [:]
        }
    }
}

let favoritesKey = "favoritesDict"

typealias Favorites = [String: [String:String]]

func mapFavorites(_ storedFavorites: Favorites) -> [Favorite] {
    return storedFavorites.values.map { artwork in
        return Favorite(
            artworkID: artwork["id"] ?? "",
            artworkName: artwork["artworkName"] ?? "",
            imageURL: optionalURL(artwork["url"]),
            artistName: artwork["artistName"] ?? ""
        )
    }
}
