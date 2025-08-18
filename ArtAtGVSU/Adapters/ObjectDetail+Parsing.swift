//
//  ObjectDetail+Parsing.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/3/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation
import CoreLocation

extension ObjectDetail {
    func parseGeoreference() -> CLLocationCoordinate2D? {
        return parseLocationGeoreference(location_georeference)
    }

    func parseMediaRepresentations() -> [URL] {
        guard let media_reps = media_reps else { return [] }

        return media_reps.splitOnPipes().map { URL(string: $0)! }
    }

    func parseRelatedWorks() -> [Artwork] {
        return parseRelatedObjects(encodedObjects: related_objects)
    }

    func joinArtists() -> String {
        guard let entity_name = entity_name else { return "" }
        return entity_name.split(separator: ";").joined(separator: ", ")
    }

    func parseSecondaryMedia() -> [SecondaryMedia] {
        guard let mediaRepresentations = secondary_media_reps,
              let thumbnails = secondary_media_rep_thumbnails,
              !mediaRepresentations.isEmpty,
              !thumbnails.isEmpty else {
            return []
        }

        let mediaList = mediaRepresentations.splitOnSemicolons()
        let thumbnailList = thumbnails.splitOnSemicolons()

        guard mediaList.count == thumbnailList.count else {
            return []
        }

        var results: [SecondaryMedia] = []

        for (media, thumbnail) in zip(mediaList, thumbnailList) {
            guard let mediaURL = URL(string: media), let thumbnailURL = URL(string: thumbnail) else {
                return []
            }
            results.append(SecondaryMedia(url: mediaURL, thumbnailURL: thumbnailURL))
        }

        return results
    }

    var isPublic: Bool {
        access == "1"
    }
}
