//
//  Artwork.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 4/25/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//
import Foundation
import MapKit
import RSWeb
import SceneKit

struct Artwork: Equatable {
    var id: String = ""
    var isPublic: Bool = false
    var mediaRepresentations: [URL] = []
    var name: String = ""
    var artistID: String = ""
    var artistName: String = ""
    var historicalContext: String = ""
    var workDescription: String = ""
    var workDate: String = ""
    var workMedium: String = ""
    var location: String = ""
    var identifier: String = ""
    var creditLine: String = ""
    var locationGeoreference: CLLocationCoordinate2D?
    var relatedWorks: [Artwork] = []
    var mediaSmall: URL?
    var mediaMedium: URL?
    var mediaLarge: URL?
    var thumbnail: URL?
    var arDigitalAsset: URL?
    var ar3dModels: [Model] = []
    var arType: String = ""

    static func == (lhs: Artwork, rhs: Artwork) -> Bool {
        lhs.id == rhs.id
    }
}

extension Artwork {
    static func fetch(id: String, transport: Transport = URLSession.shared, _ completion: @escaping (Artwork?, Error?) -> Void) {
        ArtGalleryClient.init(transport: transport).fetchObjectDetail(id: id, completion: { result in
            switch result {
            case .success(let objectDetail):
                completion(convertFrom(objectDetail: objectDetail!), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }

    static func search(term: String, transport: Transport = URLSession.shared, _ completion: @escaping ([Artwork]) -> Void) {
        ArtGalleryClient.init(transport: transport).searchObjects(term: term, completion: { result in
            switch result {
            case .success(let result):
                if let result = result {
                    completion(result.objectDetails.map { convertFrom(objectDetail: $0) })
                } else {
                    completion([])
                }
            default:
                break;
            }
        })
    }

    static func convertFrom(objectDetail: ObjectDetail) -> Artwork {
        return Artwork(
            id: String(objectDetail.object_id!),
            isPublic: objectDetail.access == "1",
            mediaRepresentations: objectDetail.parseMediaRepresentations(),
            name: objectDetail.object_name ?? "",
            artistID: objectDetail.entity_id ?? "",
            artistName: objectDetail.entity_name ?? "",
            historicalContext: objectDetail.historical_context ?? "",
            workDescription: objectDetail.work_description ?? "",
            workDate: objectDetail.work_date ?? "",
            workMedium: objectDetail.work_medium ?? "",
            location: objectDetail.location ?? "",
            identifier: objectDetail.idno ?? "",
            creditLine: objectDetail.credit_line ?? "",
            locationGeoreference: objectDetail.parseGeoreference(),
            relatedWorks: objectDetail.parseRelatedWorks(),
            mediaSmall: optionalURL(objectDetail.media_small_url),
            mediaMedium: optionalURL(objectDetail.media_medium_url),
            mediaLarge: optionalURL(objectDetail.media_large_url),
            arDigitalAsset: optionalURL(objectDetail.ar_digital_asset),
            ar3dModels: self.getModel(file: objectDetail.ar_3d_file_usdz, matrix: objectDetail.ar_coordinates),
            arType: objectDetail.ar_type ?? "artwork"
        )
    }
    
    static func getModel(file: String?, matrix: String?) -> [Model] {
        if (file == nil) {
            return []
        }
        
        var m: [Float] = []
        
        var t: SCNMatrix4? = nil
        
        do {
            m = try mapToARCoordinates(String(matrix ?? ""))
            if m.count == 16 {
                t = SCNMatrix4(
                    m11:m[0],m12:m[1],m13:m[2],m14:m[3],
                    m21:m[4],m22:m[5],m23:m[6],m24:m[7],
                    m31:m[8],m32:m[9],m33:m[10],m34:m[11],
                    m41:m[12],m42:m[12],m43:m[14],m44:m[15]
                )
            }
            print("That transformation matrix is good!")
        } catch {
            print("Invalid transformation matrix.")
        }
        

        return [
            Model(
                url: URL(string: file!)!,
                metadata: Metadata(
                    transform: t
                )
            )
        ]
    }
}

func mapToARCoordinates(_ target: String) throws -> [Float]  {
    return target
        .replacingOccurrences(of: "[", with: "")
        .replacingOccurrences(of: "]", with: "")
        .split(separator: ",")
        .map { Float($0)! }
}
