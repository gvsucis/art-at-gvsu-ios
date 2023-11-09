//
//  Entity.swift
//  ArtAtGVSU
//
//  Created by Andromeda on 11/8/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation
import Combine
import RealityKit

final class CupEntity: Entity {
//    var path: URL?
    var model: Entity?
    
    static func loadAsync(path: URL) -> AnyPublisher<CupEntity, Error> {
        print("Entity path: ", path)
        return Entity.loadAsync(named: "cup_saucer_set")
            .map { loadedCup -> CupEntity in
                let cup = CupEntity()
                loadedCup.name = "Cup"
                cup.model = loadedCup
                return cup
            }
            .eraseToAnyPublisher()
    }
}
