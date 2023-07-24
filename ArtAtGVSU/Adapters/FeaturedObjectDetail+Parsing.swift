//
//  FeaturedObjectDetail+Parsing.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/27/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

extension FeaturedObjectDetail {
    func joinArtists() -> String {
        guard let entity_name = entity_name else { return "" }
        return entity_name.split(separator: ";").joined(separator: ", ")
    }
}
