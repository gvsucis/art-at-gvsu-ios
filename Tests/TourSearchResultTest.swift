//
//  TourSearchResultTest.swift
//

import XCTest
@testable import ArtAtGVSU

class TourSearchResultTest: XCTestCase {
    let tours = """
    {
        "ok": true,
        "1": {
            "access": "1",
            "tour_id": 1,
            "tour_name": "Outside Sculpture (Allendale)",
            "tour_description": "Do you know what the big yellow sculpture is in front of Mackinac Hall or have you wondered what the big blue house looking thing is? This walking tour will take you to every outside sculpture throughout the Allendale campus. ",
            "media_icon": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/0/1217_ca_tours_icon_1_icon.jpg",
            "media_large_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/3/5/6/8/65121_ca_attribute_values_value_blob_356821_large.jpg",
            "media_medium_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/3/5/6/8/81658_ca_attribute_values_value_blob_356821_medium.jpg",
            "media_small_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/3/5/6/8/27240_ca_attribute_values_value_blob_356821_small.jpg",
            "tour_stops_id": "1;6;9;7;10;2;131;405;53;3;4;11;8",
            "tour_stops_name": "Amaranth;Arch VII: Valley;Daffodil;Eldred Sculpture;GVSU Marching Band;Heaven and Earth;L. William \\"Bill\\" Seidman;Philosohpy;Teapot;Transformational Link;Untitled;Untitled (Kinnebrew);Untitled (Obelisk)"
       }
    }
    """

    func tests_it_converts_a_complex_object() {
        let data = Data(tours.utf8)
        let decodedResult = try! JSONDecoder().decode(TourSearchResult.self, from: data)
        XCTAssertEqual(decodedResult.ok, true)
        XCTAssertEqual(decodedResult.details.count, 1)
        XCTAssertEqual(decodedResult.details[0].tour_id, 1)
        XCTAssertEqual(decodedResult.details[0].tour_name, "Outside Sculpture (Allendale)")
    }
}
