//
//  RelatedObjectsParser.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/22/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

func parseRelatedObjects(encodedObjects: String?) -> [Artwork] {
    guard let encoded = encodedObjects else { return [] }

    return encoded.split(separator: ";")
        .compactMap { destructureRelatedWork(String($0).components(separatedBy: " / ")) }
        .filter { $0.thumbnail != nil }
}

fileprivate func destructureRelatedWork(_ workFields: [String]) -> Artwork? {
    guard workFields.count == 3 else {
        return nil
    }

    return Artwork(
        id: workFields[0],
        name: workFields[1],
        thumbnail: URL(string: parseThumbnail(workFields[2]))
    )
}

fileprivate func parseThumbnail(_ thumbnailURL: String) -> String {
    if thumbnailURL.hasSuffix(",") {
        return String(thumbnailURL.dropLast())
    }
    return thumbnailURL
}
