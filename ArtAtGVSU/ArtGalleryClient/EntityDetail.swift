//
//  EntityDetail.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

struct EntityDetail: Codable {
    var ok: Bool? = false
    var access: String? = "0"
    var idno: String? = ""
    var entity_id: Int?
    var display_label: String? = ""
    var nationality: String? = ""
    var life_dates: String? = ""
    var biography: String? = ""
    var related_objects: String? = ""
}
