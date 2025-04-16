//
//  NetworkManager.swift
//  ArtAtGVSU
//
//  Created by Francis Corona on 3/16/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    // Singleton instance for global access
    static let shared = NetworkManager()

    // Private initializer to enforce singleton usage
    private init() {}

    // Sends a given image to the backend `/query` endpoint
    // The backend returns a list of related image URLs, which are fetched and returned as UIImages
    func sendImageToQueryEndpoint(_ image: UIImage, completion: @escaping (Result<[String], Error>) -> Void) {
        // Ensure the URL is valid
        let endpoint = Properties.shared.ai_search_base_url + "query"
            guard let url = URL(string: endpoint) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1)))
                return
            }

        // Create a POST request with multipart/form-data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Convert the UIImage to JPEG data
        let imageData = image.jpegData(compressionQuality: 0.8) ?? Data()

        // Construct the HTTP body using the multipart format
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"query.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle network or server error
            if let error = error {
                completion(.failure(error))
                return
            }

            // Ensure data was returned
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let ids = json?["results"] as? [String] else {
                    completion(.failure(NSError(domain: "No results found in response", code: -1)))
                    return
                }

                completion(.success(ids))
                
            } catch {
                // Handle JSON parsing error
                completion(.failure(error))
            }
        }.resume()
    }
}

extension Artwork {
    static func fetchMany(ids: [String], completion: @escaping ([Artwork]) -> Void) {
        let group = DispatchGroup()
        var artworks: [String: Artwork] = [:]

        for id in ids {
            group.enter()
            Artwork.fetch(id: id) { artwork, error in
                if let artwork = artwork {
                    artworks[id] = artwork
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            let orderedArtworks = ids.compactMap { artworks[$0] }
            completion(orderedArtworks)
        }
    }
}
