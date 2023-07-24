//
//  ObjectSearchResult.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/8/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

struct ObjectSearchResult: Decodable {
    var ok: Bool = false
    var objectDetails: [ObjectDetail] = []

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DynamicCodingKeys.self)
        try values.allKeys.forEach { key in
            if key.stringValue == "ok" {
                ok = try values.decode(Bool.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            } else {
                let detail = try values.decode(ObjectDetail.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                objectDetails.append(detail)
            }
        }
    }
}
