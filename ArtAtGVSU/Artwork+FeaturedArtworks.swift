//
//  Artwork+FeaturedArtworks.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/25/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation
import RSWeb

extension Artwork {
    static func featured(transport: Transport = URLSession.shared, _ completion: @escaping ([Artwork]) -> Void) {
        ArtGalleryClient.init(transport: transport).fetchFeaturedArt(completion: { result in
            switch result {
            case .success(let result):
                completion(convertFrom(result: result!))
            default:
                break;
            }
        })
    }

    static func convertFrom(result: FeaturedArtResult) -> [Artwork] {
        return result.objectDetails.map { objectDetail in
            Artwork(
                id: String(objectDetail.object_id!),
                isPublic: objectDetail.access == "1",
                name: objectDetail.object_name ?? "",
                artistID: objectDetail.entity_id ?? "",
                artistName: objectDetail.joinArtists(),
                historicalContext: objectDetail.historical_context ?? "",
                workDescription: objectDetail.work_description ?? "",
                identifier: objectDetail.idno ?? "",
                mediaMedium: optionalURL(objectDetail.media_medium_url),
                mediaLarge: optionalURL(objectDetail.media_large_url),
                thumbnail: optionalURL(objectDetail.media_small_url)
            )
        }.sorted(by: { $0.name < $1.name })
    }
}
