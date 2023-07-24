//
//  EntityDetail+Parsing.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

extension EntityDetail {
    func parseRelatedObjects() -> [Artwork] {
        return ArtAtGVSU.parseRelatedObjects(encodedObjects: related_objects)
    }
}
