//
//  ServerObject.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 4/11/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//
import Foundation

struct ObjectDetail: Codable, Equatable {
    var ok: Bool? = false
    var access: String = "0"
    var object_id: Int? = 0
    var idno: String? = ""
    var mimetypes: String? = ""
    var media_large_url: String? = ""
    var media_medium_url: String? = ""
    var media_small_url: String? = ""
    var media_icon_url: String? = ""
    var media_reps: String? = ""
    var object_name: String? = ""
    var entity_id: String? = ""
    var entity_name: String? = ""
    var historical_context: String? = ""
    var work_description: String? = ""
    var work_date: String? = ""
    var work_medium: String? = ""
    var location_id: String? = ""
    var location: String? = ""
    var location_notes: String? = ""
    var location_georeference: String? = ""
    var credit_line: String? = ""
    var lcsh: String? = ""
    var aat: String? = ""
    var tgn: String? = ""
    var tgn_coords: String? = ""
    var related_objects: String? = ""
    var dimensions: String? = ""
    var dimensions_width: String? = ""
    var dimensions_height: String? = ""
    var dimensions_depth: String? = ""
    var rg_thumbnail: String? = ""
    var rg_small: String? = ""
    var rg_medium: String? = ""
    var rg_large: String? = ""
    var rg_xlarge: String? = ""
    var ar_digital_asset: String? = ""
    var ar_3d_file_usdz: String? = ""
    var ar_coordinates: String? = ""
    var ar_type: String? = ""

    enum CodingKeys: String, CodingKey {
        case ok
        case access
        case object_id
        case idno
        case mimetypes
        case media_large_url
        case media_medium_url
        case media_small_url
        case media_icon_url
        case media_reps
        case object_name
        case entity_id
        case entity_name
        case historical_context
        case work_description
        case work_date
        case work_medium
        case location_id
        case location
        case location_notes
        case location_georeference
        case credit_line
        case lcsh
        case aat
        case tgn
        case tgn_coords
        case related_objects
        case dimensions
        case dimensions_width
        case dimensions_height
        case dimensions_depth
        case rg_thumbnail
        case rg_small
        case rg_medium
        case rg_large
        case rg_xlarge = "rg_x-large"
        case ar_digital_asset
        case ar_3d_file_usdz
        case ar_coordinates
        case ar_type
    }
}
