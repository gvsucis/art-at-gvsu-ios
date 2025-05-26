//
//  SearchResponse.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/26/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
  let results: [ImageResult]
}
