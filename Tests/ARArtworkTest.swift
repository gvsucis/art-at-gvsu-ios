//
//  ARArtworkTest.swift
//  Tests
//
//  Created by Josiah Campbell on 6/19/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//
import XCTest
@testable import ArtAtGVSU

class ARArtworkTest: XCTestCase {
    // Shaped after the live `objectSearch?q=featured_ar` response: one object
    // carries an AR video, the other does not.
    let json = """
    {
      "ok": true,
      "2329": {
        "access": "1",
        "object_id": 2329,
        "object_name": "Calavera de Don Quijote",
        "media_medium_url": "https://artgallery.gvsu.edu/admin/media/medium.jpg",
        "ar_digital_asset": "https://artgallery.gvsu.edu/admin/media/video.mp4",
        "ar_3d_file_usdz": "https://artgallery.gvsu.edu/admin/media/model.usdz"
      },
      "9999": {
        "access": "1",
        "object_id": 9999,
        "object_name": "No AR Here",
        "media_medium_url": "https://artgallery.gvsu.edu/admin/media/other.jpg"
      }
    }
    """

    func test_it_maps_and_filters_to_ar_artworks() {
        let result = try! JSONDecoder().decode(ObjectSearchResult.self, from: Data(json.utf8))

        let arArtworks = result.objectDetails
            .map { Artwork.convertFrom(objectDetail: $0) }
            .filter { $0.arDigitalAsset != nil }

        XCTAssertEqual(arArtworks.count, 1)
        XCTAssertEqual(arArtworks.first?.id, "2329")
        XCTAssertEqual(
            arArtworks.first?.arDigitalAsset,
            URL(string: "https://artgallery.gvsu.edu/admin/media/video.mp4")
        )
        XCTAssertEqual(
            arArtworks.first?.arModel,
            URL(string: "https://artgallery.gvsu.edu/admin/media/model.usdz")
        )
    }
}
