//
//  DynamicCodingKeys.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/25/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}
