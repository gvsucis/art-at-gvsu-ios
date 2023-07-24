//
//  JSONObjectToArray.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/15/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

/// https://swiftsenpai.com/swift/decode-dynamic-keys-json/
struct DecodedArray<T: Decodable>: Decodable {
    var values: [T]

    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tmpArray: [T] = []
        for key in container.allKeys {
            if key.stringValue == "ok" {
                continue
            }
            let decodedObject = try container.decode(T.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tmpArray.append(decodedObject)
        }
        self.values = tmpArray
    }
}
