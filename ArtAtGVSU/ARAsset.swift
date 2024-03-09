//
//  ARAsset.swift
//  ArtAtGVSU
//
//  Created by Andrea Gonzalez on 10/17/22.
//  Copyright © 2022 Applied Computing Institute. All rights reserved.
//

import Foundation
import RSWeb
import SceneKit

struct Metadata {
    let transform: SCNMatrix4?
}

struct Model {
    let url: URL
    let metadata: Metadata
}

struct ARAsset: Equatable {
    static func == (lhs: ARAsset, rhs: ARAsset) -> Bool {
        lhs.id == rhs.id
    }

    var id: String = ""
    var referenceImage: URL?
    var video: URL?
    var models: [Model] = []
}

extension ARAsset {

    static func getARResources(artwork: Artwork) async throws -> ARAsset {
        var arAsset = ARAsset(
            id: artwork.id,
            referenceImage: artwork.mediaMedium,
            video: artwork.arDigitalAsset,
            models: artwork.arTransform
        )

        let dirname = "ArtAtGvsu/\(artwork.id)"


        arAsset.video = await downloadFile(url: artwork.arDigitalAsset!, dirname: dirname)

        arAsset.referenceImage = await downloadFile(url: artwork.mediaMedium!, dirname: dirname)

        var models: [Model] = []

        for model in artwork.arTransform {
            let n = await downloadFile(url: model.url, dirname: dirname)
            models.append(Model(url: n, metadata: model.metadata))
        }

        arAsset.models = models

        return arAsset
    }

    static func downloadFile(url: URL, dirname: String) async -> URL {
        await withCheckedContinuation { continuation in
            downloadFile(url: url, dirname: dirname) { url in
                continuation.resume(returning: url)
            }
        }
    }

    static func downloadFile(url: URL, dirname: String, transport: Transport = URLSession.shared, _ completion: @escaping (URL) -> Void) {
        let filename = url.lastPathComponent

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        if !createIntermediate(dirname: dirname) {
            completion(url)
            return
        }

        let localPath = documentsDirectory.appendingPathComponent("\(dirname)/\(filename)")

        let filePath = localPath.path

        if FileManager.default.fileExists(atPath: filePath)  {
            completion(localPath)
        } else {
            ArtGalleryClient.init(transport: transport).downloadFile(url, path: localPath, completion: { url, error in
                completion(url)
            })
        }
    }

    static func createIntermediate(dirname: String) -> Bool{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(dirname)
        if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                return false
            }
        }
        return true
    }
}
