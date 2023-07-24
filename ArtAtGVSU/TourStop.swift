//
//  TourStop.swift
//  ArtAtGVSU
//
//  Created by jocmp on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation
import CoreLocation

struct TourStop: Identifiable {
    var name: String = ""
    var artworkID: String = ""
    var media: URL? = nil
    var location: CLLocationCoordinate2D? = nil
    var artwork: Artwork = Artwork()
    
    var id: String {
        return artworkID
    }
}
