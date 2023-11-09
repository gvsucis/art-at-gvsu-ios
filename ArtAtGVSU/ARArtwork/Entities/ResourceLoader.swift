//
//  ResourceLoader.swift
//  ArtAtGVSU
//
//  Created by Andromeda on 11/8/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation


import Combine
import RealityKit

class ResourceLoader {
    typealias LoadCompletion = (Result<CupEntity, Error>) -> Void
    
    private var loadCancellable: AnyCancellable?
    private var cupEntity: CupEntity?
    
    func loadResources(path: URL, completion: @escaping LoadCompletion) -> AnyCancellable? {
        guard let cupEntity else {
        
            loadCancellable = CupEntity.loadAsync(path: path).sink { result in
                print("Path to cup: ", path)
                if case let .failure(error) = result {
                    print("Failed to load CupEntity: \(error)")
                    completion(.failure(error))
                }
            } receiveValue: { [weak self] cupEntity in
                guard let self else {
                    return
                }
                self.cupEntity = cupEntity
                completion(.success(cupEntity))
            }
            return loadCancellable
        }
        completion(.success(cupEntity))
        return loadCancellable
    }
        
    func createCup(path: URL) throws -> Entity {
        Entity.loadAsync(named: "cup_saucer_set")
            .map { loadedCup -> CupEntity in
                let cup = CupEntity()
                loadedCup.name = "Cup"
                cup.model = loadedCup
                return cup
            }
            .eraseToAnyPublisher()
        
        guard let cup = cupEntity?.model else {
            throw ResourceLoaderError.resourceNotLoaded
        }
        return cup.clone(recursive: true)
    }
}

enum ResourceLoaderError: Error {
    case resourceNotLoaded
}
