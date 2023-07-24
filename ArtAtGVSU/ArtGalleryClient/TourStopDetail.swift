//
//  TourStopDetail.swift
//  ArtAtGVSU
//
//  Created by jocmp on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//
import Foundation

struct TourStopDetail: Codable {
    var ok: Bool? = false
    var access: String? = "0"
    var stop_id: Int? = nil
    var stop_name: String? = ""
    var stop_objects_id: String? = ""
    var stop_media: String? = nil
    var stop_locations: String? = ""
}
