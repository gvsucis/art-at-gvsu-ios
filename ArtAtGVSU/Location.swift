//
//  Location.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/15/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation
import RSWeb

struct Location: Equatable {
    var id: String = ""
    var name: String = ""
    var mediaMediumURL: URL?
    var mediaLargeURL: URL?
    var locations: [Location] = []
    var artworks: [Artwork] = []
}

extension Location {
    static func fetchAllCampuses(transport: Transport = URLSession.shared, _ completion: @escaping ([Location]) -> Void) {
        ArtGalleryClient(transport: transport).fetchCampuses { result in
            switch result {
            case .success(let campuses):
                completion(mapToSortedLocations(campuses))
            case .failure(_):
                break;
            }
        }
    }

    static func mapToSortedLocations(_ campuses: CampusSearchResult?) -> [Location] {
        guard let campuses = campuses else { return [] }
        return campuses.locationDetails
            .map { convertFrom(locationDetail: $0) }
            .sorted { $0.id < $1.id }
    }

    static func convertFrom(locationDetail: LocationSearchDetail) -> Location {
        return Location(
            id: String(locationDetail.location_id!),
            name: locationDetail.location_name ?? "",
            mediaMediumURL: optionalURL(locationDetail.media_medium_url),
            mediaLargeURL: optionalURL(locationDetail.media_large_url)
        )
    }
}

extension Location {
    static func fetch(id: String, transport: Transport = URLSession.shared, _ completion: @escaping (Location) -> Void) {
        ArtGalleryClient(transport: transport).fetchLocationDetail(id: id) { result in
            switch result {
            case .success(let locationDetail):
                completion(convertFrom(locationDetail: locationDetail!))
            case .failure(_):
                break;
            }
        }
    }

    static func convertFrom(locationDetail: LocationDetail) -> Location {
        return Location(
            id: String(locationDetail.location_id!),
            name: locationDetail.location_name ?? "",
            mediaMediumURL: optionalURL(locationDetail.media_medium_url),
            mediaLargeURL: optionalURL(locationDetail.media_large_url),
            locations: locationDetail.parseChildLocations(),
            artworks: locationDetail.parseRelatedObjects()
        )
    }
}
