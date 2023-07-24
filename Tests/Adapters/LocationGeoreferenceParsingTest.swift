//
//  LocationGeoreferenceParsingTest.swift
//  Tests
//
//  Created by jocmp on 6/24/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import XCTest
import Foundation
import CoreLocation
@testable import ArtAtGVSU

class LocationGeoreferenceParsingTest: XCTestCase {
    func test_parseLocationGeoreference_it_returns_nil_on_empty_georeference() {
        let result = parseLocationGeoreference("")
        XCTAssertNil(result)
    }

    func test_parseLocationGeoreference_it_strips_extra_terminating_chars() {
        let expectedLatitude = "42.9000"
        let expectedLongitude = "42.10"
        let result =
            parseLocationGeoreference("\(expectedLatitude),\(expectedLongitude)\\") // string terminates with unexpected token
        XCTAssertEqual(
            result,
            CLLocationCoordinate2D(latitude: Double(expectedLatitude)!, longitude: Double(expectedLongitude)!)
        )
    }

    func test_parseLocationGeoreference_it_returns_first_pair_on_multiple_matches() {
        let expectedLatitude = "42.901"
        let expectedLongitude = "-85.886"

        let result = parseLocationGeoreference("[42.901,-85.886] 42.901,-85.886")

        XCTAssertEqual(
            result,
            CLLocationCoordinate2D(latitude: Double(expectedLatitude)!, longitude: Double(expectedLongitude)!)
        )
    }

    func test_parseLocationGeoreference_it_handles_pair_brackets_in_any_order() {
        let expectedLatitude = "42.96003"
        let expectedLongitude = "-85.68134"
        let result = parseLocationGeoreference("\(expectedLatitude), \(expectedLongitude) [\(expectedLatitude),\(expectedLongitude)]")
        XCTAssertEqual(
            result,
            CLLocationCoordinate2D(latitude: Double(expectedLatitude)!, longitude: Double(expectedLongitude)!)
        )
    }

    func test_parseLocationGeoreference_it_returns_coordinates_on_valid_match() {
        let latitude = 42.962858349348
        let longitude = -85.886878535968

        let coordinates = parseLocationGeoreference("[\(latitude),\(longitude)]")!
        XCTAssertEqual(coordinates.latitude, latitude)
        XCTAssertEqual(coordinates.longitude, longitude)
    }

    func test_parseLocationGeoreference_it_returns_null_on_uneven_pairs() {
        let latitude = "42.901"
        let longitude = "-85.886"

        let result = parseLocationGeoreference("[\(latitude),\(longitude)] \(latitude)")
        XCTAssertNil(result)
    }

    func test_it_rejects_invalid_coordinates() {
        // Edge case. Tokenizer will parse lat=1.0 and long=49401.0 instead of 42.964,-85.887
        let location = "{1 N Campus Dr, Allendale Charter Township, MI 49401, USA [42.964,-85.887]"
        XCTAssertNil(parseLocationGeoreference(location))
    }
}
