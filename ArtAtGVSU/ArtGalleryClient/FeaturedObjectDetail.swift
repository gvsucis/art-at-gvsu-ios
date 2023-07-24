//
//  FeaturedObjectDetail.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/25/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

struct FeaturedObjectDetail: Codable {
    var access: String? = "0"
    var object_id: Int?
    var idno: String? = ""
    var media_icon_url: String? = ""
    var media_large_url: String? = ""
    var media_medium_url: String? = ""
    var media_small_url: String? = ""
    var reps: String? = ""
    var object_name: String? = ""
    var entity_id: String? = ""
    var entity_name: String? = ""
    var historical_context: String? = ""
    var work_description: String? = ""
}
