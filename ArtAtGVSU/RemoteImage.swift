//
//  RemoteImage.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/25/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation
import SDWebImage

struct RemoteImage {
    static func fetch(url: URL?, completion: @escaping (UIImage) -> Void) {
        SDWebImageManager.shared.loadImage(with: url, progress: { _,_,_ in }, completed: { image,_,_,_,_,_ in
            if let image = image {
                completion(image)
            }
        })
    }
}
