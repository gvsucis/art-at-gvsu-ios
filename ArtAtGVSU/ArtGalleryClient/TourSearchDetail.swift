//
//  SearchTourDetail.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation

struct TourSearchDetail: Codable {
    var access: String = "0"
    var tour_id: Int?
    var tour_name: String? = ""
    var tour_description: String? = ""
    var media_icon: String? = nil
    var media_large_url: String? = nil
    var media_medium_url: String? = nil
    var media_small_url: String? = nil
    var tour_stops_id: String? = nil
    var tour_stops_name: String? = nil
}
