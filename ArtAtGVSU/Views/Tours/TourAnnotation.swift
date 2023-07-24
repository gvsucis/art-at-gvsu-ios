//
//  TourAnnotation.swift
//  ArtAtGVSU
//
//  Created by jocmp on 6/26/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//
import MapKit

class TourAnnotation: NSObject, MKAnnotation, Identifiable {
    var tourStop: TourStop
    
    init(tourStop: TourStop) {
        self.tourStop = tourStop
    }
    
    var id: String {
        return tourStop.artworkID
    }
    
    var title: String? {
        return tourStop.name
    }
    
    var canShowCallout: Bool {
        return true
    }
    
    var coordinate: CLLocationCoordinate2D {
        return tourStop.location!
    }
}
