//
//  Artist.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation
import RSWeb

struct Artist {
    var id: String
    var name: String = ""
    var lifeDatesSummary: String = ""
    var nationality: String = ""
    var biography: String = ""
    var relatedWorks: [Artwork] = []    
}

extension Artist {
    static func fetch(id: String, transport: Transport = URLSession.shared, _ completion: @escaping (Artist) -> Void) {
        ArtGalleryClient.init(transport: transport).fetchEntityDetail(id: id, completion: { result in
            switch result {
            case .success(let entityDetail):
                completion(convertFrom(entityDetail: entityDetail!))
            default:
                break;
            }
        })
    }

    static func search(term: String, transport: Transport = URLSession.shared, _ completion: @escaping ([Artist]) -> Void) {
        ArtGalleryClient.init(transport: transport).searchEntities(term: term, completion: { result in
            switch result {
            case .success(let result):
                if let result = result {
                    completion(result.entityDetails.map { convertFrom(entityDetail: $0) })
                } else {
                    completion([])
                }
            default:
                break;
            }
        })
    }

    static func convertFrom(entityDetail: EntityDetail) -> Artist {
        return Artist(
            id: String(entityDetail.entity_id!),
            name: entityDetail.display_label ?? "",
            lifeDatesSummary: entityDetail.life_dates ?? "",
            nationality: entityDetail.nationality ?? "",
            biography: entityDetail.biography ?? "",
            relatedWorks: entityDetail.parseRelatedObjects()
        )
    }
}
