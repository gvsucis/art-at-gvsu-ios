//
//  GalleryObjectTest.swift
//  Tests
//
//  Created by Josiah Campbell on 4/11/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import XCTest
@testable import ArtAtGVSU

class ObjectDetailParsingTest: XCTestCase {
    func test_parseMediaRepresentations_it_splits_pipes_into_url_array() throws {
        let object = ObjectDetail(media_reps: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/81355_ca_object_representations_media_14447_large.jpg|https://artgallery.gvsu.edu/admin/media/collectiveaccess/quicktime/1/4/8/46990_ca_object_representations_media_14812_original.m4v")

        XCTAssertEqual(object.parseMediaRepresentations(), [
            URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/81355_ca_object_representations_media_14447_large.jpg"),
            URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/quicktime/1/4/8/46990_ca_object_representations_media_14812_original.m4v")
        ])
    }

    func test_decoding() throws {
        let json = """
        {
        "ok": true,
        "access": "1",
        "object_id": 12851,
        "idno": "2013.68.5",
        "mimetypes": "image/jpeg|video/mp4",
        "media_large_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/81355_ca_object_representations_media_14447_large.jpg",
        "media_medium_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/62308_ca_object_representations_media_14447_medium.jpg",
        "media_small_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/74970_ca_object_representations_media_14447_small.jpg",
        "media_icon_url": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/5035_ca_object_representations_media_14447_icon.jpg",
        "media_reps": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/81355_ca_object_representations_media_14447_large.jpg|https://artgallery.gvsu.edu/admin/media/collectiveaccess/quicktime/1/4/8/46990_ca_object_representations_media_14812_original.m4v",
        "object_name": "Black Demon [Angel]",
        "entity_id": "3734",
        "entity_name": "Grisha Bruskin",
        "historical_context": "Grisha Bruskin burst onto the international contemporary art scene in July 1988, when Sotheby’s held its first auction in Moscow. Although he was a well-known underground painter, sculptor, and writer in the Soviet Union, Bruskin had been invisible to most in the West. Shortly after the auction, Bruskin immigrated to New York, where he now lives and works. Bruskin tends to create in series; researching and presenting variations on themes that include elements from his Jewish heritage (including sacred texts, mysticism, and mythological figures) as well as imagery from the former Soviet Union. \\"Black Demon [Angel]\\" was created as part of his Metamorphoses series, which includes both multi-figured paintings as well as two-dimensional sculpture. ",
        "work_description": "",
        "work_date": "ca 1993",
        "work_medium": "Enamel on steel",
        "location_id": "1574",
        "location": "Shelf P3 (OS)",
        "location_notes": "IDC; Open Shelving; Section P; Shelf P3",
        "location_georeference": null,
        "credit_line": "A Gift of the Stuart and Barbara Padnos Foundation",
        "lcsh": "Art, Russian--20th century [info:lc/authorities/subjects/sh2001010476];Sculpture [info:lc/authorities/subjects/sh85119004];Metalwork [info:lc/authorities/childrensSubjects/sj96005951]",
        "aat": "sculpture;steels;enamel",
        "tgn": null,
        "tgn_coords": ",",
        "related_objects": "",
        "dimensions": "16.75 in x 23 in x 9 in",
        "dimensions_width": "16.75 in",
        "dimensions_height": "23 in",
        "dimensions_depth": "9 in",
        "rg_thumbnail": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/92067_ca_object_representations_media_14447_rg_thumbnail.jpg",
        "rg_small": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/21173_ca_object_representations_media_14447_rg_small.jpg",
        "rg_medium": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/64759_ca_object_representations_media_14447_rg_medium.jpg",
        "rg_large": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/17093_ca_object_representations_media_14447_rg_large.jpg",
        "rg_x-large": "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/20347_ca_object_representations_media_14447_rg_x-large.jpg"
        }
        """

        let data = json.data(using: .utf8)!
        XCTAssertNotNil(try JSONDecoder().decode(ObjectDetail.self, from: data))
    }

    func test_parseGeoreference_it_returns_nil_on_nil_georeference() throws {
        let object = ObjectDetail(location_georeference: nil)
        XCTAssertNil(object.parseGeoreference())
    }

    func test_parseGeoreference_it_returns_nil_on_empty_georeference() throws {
        let object = ObjectDetail(location_georeference: "")
        XCTAssertNil(object.parseGeoreference())
    }

    func test_parseGeoreference_it_strips_unexpected_tokens() throws {
        let object = ObjectDetail(location_georeference: "42.9000,42.10\\") // string terminates with unexpected token
        let coordinates = object.parseGeoreference()!
        
        XCTAssertEqual(coordinates.latitude, 42.9)
        XCTAssertEqual(coordinates.longitude, 42.1)
    }

    func test_parseGeoreference_it_parses_first_pair_on_multiple_matches() throws {
        let object = ObjectDetail(location_georeference: "[42.901,-85.886] 42.901,-85.886")
     
        let coordinates = object.parseGeoreference()!

        XCTAssertEqual(coordinates.latitude, 42.901)
        XCTAssertEqual(coordinates.longitude, -85.886)
    }

    func test_parseGeoreference_it_returns_coordinates_on_valid_match() throws {
        let latitude = 42.962858349348
        let longitude = -85.886878535968

        let object = ObjectDetail(location_georeference: "[\(latitude),\(longitude)]")
        let coordinates = object.parseGeoreference()
        XCTAssertEqual(coordinates!.latitude, latitude)
        XCTAssertEqual(coordinates!.longitude, longitude)
    }

    func test_parseRelatedObjects_it_returns_a_single_object() throws {
        let related_objects = "3817 / Dutchman with Canal Boat / https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/5/6/2171_ca_object_representations_media_15698_small.jpg,"
        let object = ObjectDetail(related_objects: related_objects)

        XCTAssertEqual(object.parseRelatedWorks(), [
            Artwork(
                id: "3817",
                name: "Dutchman with Canal Boat",
                thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/5/6/2171_ca_object_representations_media_15698_small.jpg")
            )
        ])
    }

    func test_parseArtists() {
        let object = ObjectDetail(entity_name: "Nick Cave;Bob Faust")
        XCTAssertEqual(object.joinArtists(), "Nick Cave, Bob Faust")
    }
}
