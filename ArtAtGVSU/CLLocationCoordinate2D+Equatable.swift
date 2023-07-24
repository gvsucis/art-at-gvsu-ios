//
//  CLLocationCoordinate2D+Equatable.swift
//  ArtAtGVSU
//
//  Created by jocmp on 6/24/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//
import CoreLocation

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
