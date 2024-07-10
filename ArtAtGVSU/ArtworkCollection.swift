//
//  ArtworkCollection.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/29/24.
//  Copyright © 2024 Applied Computing Institute. All rights reserved.
//

import Foundation

enum ArtworkCollection: String {
    case featuredArt = "featured_art"
    case featuredAR = "featured_ar"

    var slug: String {
        rawValue
    }
}
