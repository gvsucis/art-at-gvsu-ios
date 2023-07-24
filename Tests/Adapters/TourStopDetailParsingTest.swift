//
//  TourStopDetail+ParsingTest.swift
//  Tests
//
//  Created by jocmp on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import XCTest
import Foundation
@testable import ArtAtGVSU

class TourStopDetailParsingExtTest: XCTestCase {

    func tests_it_returns_a_single_media_url() {
        let stop = TourStopDetail(
            stop_media: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/9/7/94671_ca_object_representations_media_9726_small.jpg"
        )
        let media = stop.toDomainModel().media
        XCTAssertEqual(
            media,
            URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/9/7/94671_ca_object_representations_media_9726_small.jpg")
        )
    }

    func tests_it_parses_the_first_valid_media_url() {
        let stop = TourStopDetail(
            stop_media: "/admin/media/collectiveaccess/images/8/44219_ca_object_representations_media_871_small.jpg; https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/9/7/94671_ca_object_representations_media_9726_small.jpg"
        )
        let media = stop.toDomainModel().media
        XCTAssertEqual(
            media,
            URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/9/7/94671_ca_object_representations_media_9726_small.jpg")
        )
    }
}
