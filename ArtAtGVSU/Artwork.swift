//
//  Artwork.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 4/25/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//
import Foundation
import MapKit
import Web

struct SecondaryMedia: Equatable {
    let url: URL
    let thumbnailURL: URL
}

struct Artwork: Equatable {
    var id: String = ""
    var isPublic: Bool = false
    var mediaRepresentations: [URL] = []
    var secondaryMedia: [SecondaryMedia] = []
    var name: String = ""
    var artistID: String = ""
    var artistName: String = ""
    var historicalContext: String = ""
    var workDescription: String = ""
    var workDate: String = ""
    var workMedium: String = ""
    var locationID: String = ""
    var location: String = ""
    var identifier: String = ""
    var creditLine: String = ""
    var locationGeoreference: CLLocationCoordinate2D?
    var relatedWorks: [Artwork] = []
    var mediaSmall: URL?
    var mediaMedium: URL?
    var mediaLarge: URL?
    var thumbnail: URL?
    var arDigitalAsset: URL?
    var arModel: URL?

    static func == (lhs: Artwork, rhs: Artwork) -> Bool {
        lhs.id == rhs.id
    }
}

extension Artwork {
    static func fetch(id: String, transport: Transport = URLSession.shared, _ completion: @escaping (Artwork?, Error?) -> Void) {
        ArtGalleryClient.init(transport: transport).fetchObjectDetail(id: id, completion: { result in
            switch result {
            case .success(let objectDetail):
                completion(convertFrom(objectDetail: objectDetail!), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }

    static func search(term: String, limit: Int? = nil, transport: Transport = URLSession.shared, _ completion: @escaping ([Artwork]) -> Void) {
        ArtGalleryClient.init(transport: transport).searchObjects(term: term, limit: limit, completion: { result in
            switch result {
            case .success(let result):
                if let result = result {
                    completion(result.objectDetails.map { convertFrom(objectDetail: $0) })
                } else {
                    completion([])
                }
            default:
                break;
            }
        })
    }

    static func convertFrom(objectDetail: ObjectDetail) -> Artwork {
        return Artwork(
            id: String(objectDetail.object_id!),
            isPublic: objectDetail.access == "1",
            mediaRepresentations: objectDetail.parseMediaRepresentations(),
            secondaryMedia: objectDetail.parseSecondaryMedia(),
            name: objectDetail.object_name ?? "",
            artistID: objectDetail.entity_id ?? "",
            artistName: objectDetail.entity_name ?? "",
            historicalContext: objectDetail.historical_context ?? "",
            workDescription: objectDetail.work_description ?? "",
            workDate: objectDetail.work_date ?? "",
            workMedium: objectDetail.work_medium ?? "",
            locationID: objectDetail.location_id ?? "",
            location: objectDetail.location ?? "",
            identifier: objectDetail.idno ?? "",
            creditLine: objectDetail.credit_line ?? "",
            locationGeoreference: objectDetail.parseGeoreference(),
            relatedWorks: objectDetail.parseRelatedWorks(),
            mediaSmall: optionalURL(objectDetail.media_small_url),
            mediaMedium: optionalURL(objectDetail.media_medium_url),
            mediaLarge: optionalURL(objectDetail.media_large_url),
            thumbnail: optionalURL(objectDetail.media_small_url),
            arDigitalAsset: optionalURL(objectDetail.ar_digital_asset),
            arModel: optionalURL(objectDetail.ar_3d_file_usdz)
        )
    }

    /// Fetches every artwork in the gallery's AR set (`objectSearch?q=featured_ar`),
    /// keeping only those that actually carry a playable AR video.
    static func fetchARArtworks(transport: Transport = URLSession.shared) async -> [Artwork] {
        await withCheckedContinuation { continuation in
            ArtGalleryClient(transport: transport).fetchARArt { result in
                switch result {
                case .success(let searchResult):
                    let artworks = (searchResult?.objectDetails ?? [])
                        .map { convertFrom(objectDetail: $0) }
                        .filter { $0.arDigitalAsset != nil }
                    continuation.resume(returning: artworks)
                case .failure:
                    continuation.resume(returning: [])
                }
            }
        }
    }
}
