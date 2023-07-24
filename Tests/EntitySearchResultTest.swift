//
//  EntitySearchResultTest.swift
//  Tests
//
//  Created by Josiah Campbell on 8/8/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//
import XCTest
@testable import ArtAtGVSU

class EntitySearchResultTest: XCTestCase {
    let entities = """
    {
      "ok": true,
      "2599": {
        "access": "1",
        "idno": "",
        "entity_id": 2599,
        "display_label": "Jason C.H.C",
        "nationality": "Chinese",
        "life_dates": null,
        "biography": "",
        "related_objects": "8589 / Space Rocket / https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/5/0/55901_ca_object_representations_media_5072_small.jpg,"
      }
    }
    """

    func tests_it_converts_a_complex_object() {
        let data = Data(entities.utf8)
        let decodedResult = try! JSONDecoder().decode(EntitySearchResult.self, from: data)
        XCTAssertEqual(decodedResult.ok, true)
        XCTAssertEqual(decodedResult.entityDetails.count, 1)
        XCTAssertEqual(decodedResult.entityDetails[0].entity_id, 2599)
    }
}
