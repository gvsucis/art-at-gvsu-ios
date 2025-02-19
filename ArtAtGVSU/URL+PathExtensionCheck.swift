//
//  URL+PathExtensionCheck.swift
//
//
//  Created by Josiah Campbell on 5/2/21.
//

import Foundation

let ART_GALLERY_VIDEO_EXTENSIONS = [
    "m4v",
    "mp4"
]

extension URL {
    var hasVideoExtension: Bool {
        ART_GALLERY_VIDEO_EXTENSIONS.contains(pathExtension)
    }
}
