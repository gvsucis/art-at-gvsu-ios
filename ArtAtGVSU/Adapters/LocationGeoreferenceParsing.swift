//
//  LocationGeoreferenceParsing.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/24/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation
import CoreLocation
import DequeModule

func parseLocationGeoreference(_ locationGeoreference: String?) -> CLLocationCoordinate2D? {
    guard let locationGeoreference = locationGeoreference else { return nil }
    let compactGeoreference = locationGeoreference.replacingOccurrences(of: " ", with: "")
    var coordinates: [Double] = []
    var deque: Deque<Character> =  []
    
    for (index, token) in compactGeoreference.enumerated() {
        if (token == "-" || token == "." || token.isNumber) {
            deque.append(token)
        } else if (token == "[" || token == "]" || token == ",") {
            if (deque.isEmpty) {
                continue
            }
            dequeueIntoCoordinate(&deque, &coordinates)
        }
        
        if (index == compactGeoreference.count - 1 && !deque.isEmpty) {
            dequeueIntoCoordinate(&deque, &coordinates)
        }
    }

    if (coordinates.count < 2 || coordinates.count % 2 != 0) {
        return nil
    }

    let latitude = coordinates[0]
    let longitude = coordinates[1]

    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
}

private func dequeueIntoCoordinate(_ deque: inout Deque<Character>, _  coordinates: inout [Double]) {
    var coordinate = ""
    while (!deque.isEmpty) {
        coordinate += String(deque.removeFirst())
    }

    guard let numericCoordinate = Double(coordinate) else { return }
  
    if (isValidCoordinate(numericCoordinate)) {
        coordinates.append(numericCoordinate)
    }
}

private func isValidCoordinate(_ coordinate: Double) -> Bool {
    (MIN_LONGITUDE...MAX_LONGITUDE).contains(coordinate)
}

// https://en.wikipedia.org/wiki/Geographic_coordinate_system
// Longitude can be represented as -90 to +90 while
// longitude is -180 to +180
let MAX_LONGITUDE = Double(180)
let MIN_LONGITUDE = Double(-180)
