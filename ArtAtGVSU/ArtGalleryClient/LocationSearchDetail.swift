//
//  LocationDetail.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/15/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

struct LocationSearchDetail: Codable {
    var access: String = "0"
    var location_id: Int?
    var location_name: String? = ""
    var location_description: String? = ""
    var media_large_url: String? = ""
    var media_medium_url: String = ""
    var media_small_url: String? = ""
    var media_icon: String? = ""
    var child_location_id: String? = ""
    var child_location_name: String? = ""
    var location_georeference: String? = ""
    var related_objects: String? = ""
}
