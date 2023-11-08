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
import ARKit

struct Metadata {
    let transform: SCNMatrix4?
}

struct Model {
    let url: URL
    let metadata: Metadata
}

struct ARArtwork: Equatable {
    static func == (lhs: ARArtwork, rhs: ARArtwork) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String = ""
    var referenceImage: URL?
    var video: URL?
    var models: [Model] = []
    var type: String = ""
    var refimg: ARReferenceImage?
}

extension ARArtwork {
    
    static func getARResources(artwork: Artwork) async throws -> ARArtwork {
        var arAsset = ARArtwork(
            id: artwork.id,
            referenceImage: artwork.mediaMedium,
            video: artwork.arDigitalAsset,
            models: artwork.ar3dModels,
            type: artwork.id == "32481" ? "sculpture" : "artwork", //TODO: Replace with artwork.arType
            refimg: nil
        )
        
        let dirname = "ArtAtGvsu/\(artwork.id)"
        
        
        arAsset.video = await downloadFile(url: artwork.arDigitalAsset!, dirname: dirname)
        
        arAsset.referenceImage = await downloadFile(url: artwork.mediaMedium!, dirname: dirname)
        
        let img = try? await artworkconfig2(imageRef: arAsset.referenceImage!, name: artwork.id)
        
        print("LOADED IMAGE ASSET: \(String(describing: artwork.name))");
        guard let cgImage = img?.cgImage else { throw "Error" }
        
        let imageWidth = CGFloat(cgImage.width) * 0.0002645833
        
        print("Image width: \(imageWidth)")
        
        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: imageWidth)
        arImage.name = "ARImage-\(artwork.name)"
        
        arImage.validate { [] (error) in
            if let error = error {
                print("Reference image validation failed: \(error.localizedDescription)")
//                return
            }
        
        }
        
        arAsset.refimg = arImage
        
        var models: [Model] = []
        
        for model in artwork.ar3dModels {
            let n = await downloadFile(url: model.url, dirname: dirname)
            models.append(Model(url: n, metadata: model.metadata))
        }
        
        arAsset.models = models
                
        return arAsset
    }
    
    static func downloadFile(url: URL, dirname: String) async -> URL {
        await withCheckedContinuation { continuation in
            downloadFile(url: url, dirname: dirname) { url in
                print("[DEBUG] [ARAsset::downloadFile] returned url: \(url)")
                continuation.resume(returning: url)
            }
        }
    }
    
    static func artworkconfig2(imageRef: URL, name: String) async throws -> UIImage? {
        print("configuring...... \(name)");
        let data = try Data(contentsOf: imageRef)
        return UIImage(data: data)
    }
    
    static func downloadFile(url: URL, dirname: String, transport: Transport = URLSession.shared, _ completion: @escaping (URL) -> Void) {
        let filename = url.lastPathComponent
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        if !createIntermediate(dirname: dirname) {
            print("Unable to create intermediate directories for: \(dirname)")
            completion(url)
            return
        }
        
        let localPath = documentsDirectory.appendingPathComponent("\(dirname)/\(filename)")
        
        let filePath = localPath.path
        
        if FileManager.default.fileExists(atPath: filePath)  {
            print("[DEBUG] [ARAsset::downloadFile] Path to file already exists.")
            completion(localPath)
        } else {
            print("[DEBUG] [ARAsset::downloadFile] Making request")
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
                print("Directories created: ")
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        return true
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
