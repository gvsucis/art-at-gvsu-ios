//
//  ObjectSearchResultTest.swift
//  Tests
//
//  Created by Josiah Campbell on 8/8/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//
import XCTest
@testable import ArtAtGVSU

class ObjectSearchResultTest: XCTestCase {
    let objects = """
    {
      "ok": true,
      "10493": {
        "access": "1",
        "object_id": 10493,
        "idno": "2016.65.21",
        "media_icon_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/10055_ca_object_representations_media_17379_icon.jpg",
        "media_large_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/41356_ca_object_representations_media_17379_large.jpg",
        "media_medium_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/33869_ca_object_representations_media_17379_medium.jpg",
        "media_small_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/65590_ca_object_representations_media_17379_small.jpg",
        "reps": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/41356_ca_object_representations_media_17379_large.jpg",
        "object_name": "Chrysanthemums",
        "entity_id": "637",
        "entity_name": "Alten, Mathias Joseph",
        "historical_context": "",
        "work_description": "Still life of yellow and white chrysanthemum flowers against a dark background and a fabric covered table.",
        "work_date": "ca. 1900",
        "work_medium": "Oil on Canvas",
        "location_id": "645",
        "location": "On Loan",
        "location_notes": "On Loan; GRAM",
        "location_georeference": null,
        "credit_line": "Gift of George H. and Barbara Gordon",
        "related_objects": "9508 / Irises / https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/5/7/58707_ca_object_representations_media_15727_small.jpg,;12156 / Roses on Tabletop / https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/5/7/83941_ca_object_representations_media_15728_small.jpg,;15413 / Pink and White Roses, Portland / https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/6/8/82175_ca_object_representations_media_16864_small.jpg,"
      }
    }
    """

    func tests_it_converts_a_complex_object() {
        let data = Data(objects.utf8)
        let decodedResult = try! JSONDecoder().decode(ObjectSearchResult.self, from: data)
        XCTAssertEqual(decodedResult.ok, true)
        XCTAssertEqual(decodedResult.objectDetails.count, 1)
        XCTAssertEqual(decodedResult.objectDetails[0].object_id, 10493)
    }
}
