//
//  Links.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 12/1/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation

struct Links {
    static func artworkDetail(id: String) -> URL {
        return URL(string: "https://artgallery.gvsu.edu/Detail/objects/\(id)")!
    }
    
    static func fromDetailLink(_ link: String) -> String? {
        guard let url = URL(string: link) else {
            return nil
        }
        
        if (!url.isDetailLink || url.pathComponents.isEmpty) {
            return nil
        }
        
        return url.pathComponents.last
    }
}

private extension URL {
    var isDetailLink: Bool {
        return scheme == "http" || scheme == "https" &&
            host == "artgallery.gvsu.edu"
    }
}
