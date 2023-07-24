//
//  EntityDetailParsingTest.swift
//  Tests
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import XCTest
@testable import ArtAtGVSU

class EntityDetailParsingTest: XCTestCase {
    func test_it_converts_related_objects_into_artworks() {
        let entity = EntityDetail(
            entity_id: 1415,
            related_objects: "4032 / La Grande Vitesse / https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/2/0/3/43867_ca_object_representations_media_20360_small.jpg,;4075 / La Grande Vitesse / https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/2/0/3/47017_ca_object_representations_media_20359_small.jpg,"
        )

        let expectedArtworks = [
            Artwork(id: "4032", name: "La Grand Vitesse", thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/2/0/3/43867_ca_object_representations_media_20360_small.jpg")!),
            Artwork(id: "4075", name: "La Grand Vitesse", thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/2/0/3/47017_ca_object_representations_media_20359_small.jpg")!),
        ]

        XCTAssertEqual(entity.parseRelatedObjects() , expectedArtworks)
    }
}
