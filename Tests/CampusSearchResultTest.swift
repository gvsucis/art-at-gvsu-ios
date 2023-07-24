//
//  CampusSearchResultTest.swift
//
//
//  Created by Josiah Campbell on 5/15/21.
//

import XCTest
@testable import ArtAtGVSU

class CampusSearchResultTest: XCTestCase {
    let campuses = """
    {
      "ok": true,
      "453": {
        "access": "1",
        "location_id": 453,
        "location_name": "Detroit Regional Center",
        "location_description": "The GVSU Detroit Center will house classrooms for both the Grand Valley Charter Schools Office and the College of Education. It will also hold the regional offices for the Small Business and Technology Development Center and will serve as a central meeting location for Grand Valley professionals conducting business in southeast Michigan.",
        "media_icon_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/6/3/28129_ca_object_representations_media_16392_icon.jpg",
        "media_large_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/6/3/91827_ca_object_representations_media_16392_large.jpg",
        "media_medium_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/6/3/892_ca_object_representations_media_16392_medium.jpg",
        "media_small_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/6/3/50277_ca_object_representations_media_16392_small.jpg",
        "media_icon": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/4/74663_ca_storage_locations_icon_453_icon.jpg",
        "child_location_id": "454",
        "child_location_name": "Detroit Center",
        "related_objects": ""
      }
    }
    """

    func tests_it_converts_a_complex_object() {
        let data = Data(campuses.utf8)
        let decodedResult = try! JSONDecoder().decode(CampusSearchResult.self, from: data)
        XCTAssertEqual(decodedResult.ok, true)
        XCTAssertEqual(decodedResult.locationDetails.count, 1)
        XCTAssertEqual(decodedResult.locationDetails[0].location_id, 453)
    }
}
