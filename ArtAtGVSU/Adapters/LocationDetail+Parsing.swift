//
//  LocationDetail+Parsing.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/16/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

extension LocationDetail {
    func parseChildLocations() -> [Location] {
        guard let idsString = child_location_id else { return [] }
        guard let namesString = child_location_name else { return [] }

        let ids = idsString.split(separator: ";")
        let names = namesString.split(separator: ";")

        let idsAndNamesLengthAreTheSame = ids.count == names.count
        guard idsAndNamesLengthAreTheSame else { return [] }

        return zip(ids, names).map { id, name in
            Location(id: String(id), name: String(name))
        }
    }

    func parseRelatedObjects() -> [Artwork] {
        return ArtAtGVSU.parseRelatedObjects(encodedObjects: related_objects)
    }
}
