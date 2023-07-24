//
//  File.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/9/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

struct Links {
    static func artworkDetail(id: String) -> URL {
        return URL(string: "https://artgallery.gvsu.edu/Detail/objects/\(id)")!
    }
}
