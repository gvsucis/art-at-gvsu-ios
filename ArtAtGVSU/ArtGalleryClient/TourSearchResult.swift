//
//  TourSearchResult.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation

struct TourSearchResult: Decodable {
    var ok: Bool = false
    var details: [TourSearchDetail] = []

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DynamicCodingKeys.self)
        try values.allKeys.forEach { key in
            if key.stringValue == "ok" {
                ok = try values.decode(Bool.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            } else {
                let detail = try values.decode(TourSearchDetail.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                details.append(detail)
            }
        }
    }
}
