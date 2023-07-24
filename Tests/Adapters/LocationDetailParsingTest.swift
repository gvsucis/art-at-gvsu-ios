//
//  LocationDetailParsingTest.swift
//  Tests
//
//  Created by Josiah Campbell on 5/16/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import XCTest
@testable import ArtAtGVSU

class LocationDetailParsingTest: XCTestCase {
    let childLocationIDs = ""
    let childLocationNames = ""

    func test_it_zips_child_location_ids_and_names_into_locations() throws {
        let locationDetail = LocationDetail(
            child_location_id: "606;607;608",
            child_location_name: "Ground Floor (JHZ);1st Floor (JHZ);2nd Floor (JHZ)"
        )

        let expectedLocations = [
            Location(id: "606", name: "Ground Floor (JHZ)"),
            Location(id: "607", name: "1st Floor (JHZ)"),
            Location(id: "608", name: "2nd Floor (JHZ)"),
        ]

        XCTAssertEqual(locationDetail.parseChildLocations(), expectedLocations)
    }

    func test_it_splits_related_objects_into_artworks() throws {
        let related_objects = "3170 / Heaven and Earth / http://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/0/0/8999_ca_object_representations_media_10086_small.jpg;3171 / Transformational Link / http://artgallery.gvsu.edu/admin/media/collectiveaccess/images/7/3/98107_ca_object_representations_media_7384_small.jpg"

        let locationDetail = LocationDetail(
            related_objects: related_objects
        )

        let expectedArtworks = [
            Artwork(
                id: "3170",
                name: "Heaven and Earth",
                thumbnail: URL(string: "http://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/0/0/8999_ca_object_representations_media_10086_small.jpg")!
            ),
            Artwork(
                id: "3171",
                name: "Transformational Link",
                thumbnail: URL(string: "http://artgallery.gvsu.edu/admin/media/collectiveaccess/images/7/3/98107_ca_object_representations_media_7384_small.jpg")!
            )
        ]

        XCTAssertEqual(locationDetail.parseRelatedObjects(), expectedArtworks)
    }
}
