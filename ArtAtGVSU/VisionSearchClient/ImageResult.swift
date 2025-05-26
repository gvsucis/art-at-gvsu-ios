//
//  ImageResult.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/26/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import Foundation

struct ImageResult: Codable, Identifiable {
  let object_id: String
  let image_url: String

  var id: String {
    return image_url
  }

  var imageURL: URL {
    return URL(string: image_url)!
  }
}
