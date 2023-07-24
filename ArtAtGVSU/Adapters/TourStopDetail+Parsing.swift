//
//  TourStopDetail+Parsing.swift
//  ArtAtGVSU
//
//  Created by jocmp on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation

extension TourStopDetail {
    func toDomainModel() -> TourStop {
        return TourStop(
            name: stop_name ?? "",
            artworkID: String(stop_objects_id!),
            media: parseStopMedia(stop_media),
            location: parseLocationGeoreference(stop_locations)
        )
    }
}

private func parseStopMedia(_ stopMedia: String?) -> URL? {
    guard let stopMedia = stopMedia else { return nil }
    let compactStopMedia = stopMedia.replacingOccurrences(of: " ", with: "")

    let optionalURLs = compactStopMedia
        .split(separator: ";")
        .compactMap { optionalURL(String($0)) }
        .filter { $0.scheme != nil }

    return optionalURLs.first
}
