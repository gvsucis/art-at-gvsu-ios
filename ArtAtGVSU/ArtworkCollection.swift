//
//  ArtworkCollection.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/29/24.
//  Copyright © 2024 Applied Computing Institute. All rights reserved.
//

import Foundation

enum ArtworkCollection: String {
    case featuredArtwork = "featured_art"
    case ar = "AR_Alten_2022"

    var slug: String {
        rawValue
    }
}
