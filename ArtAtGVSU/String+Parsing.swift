//
//  GalleryHelpers.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 4/11/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//


extension String {
    func splitOnPipes() -> [String] {
        return split(separator: "|").map { String($0) }
    }
}
