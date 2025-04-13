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

    /// Sends a given image to the backend `/query` endpoint
    /// The backend returns a list of related image URLs, which are fetched and returned as UIImages
    func sendImageToQueryEndpoint(_ image: UIImage, completion: @escaping (Result<[UIImage], Error>) -> Void) {
        // Ensure the URL is valid
        guard let url = URL(string: "http://192.168.0.232:8000/query") else {
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
                // Parse the JSON response: expected format is { "results": ["http://...", ...] }
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let urlStrings = json?["results"] as? [String] else {
                    completion(.failure(NSError(domain: "No results found in response", code: -1)))
                    return
                }

                var images: [UIImage] = []
                let group = DispatchGroup()

                // For each image URL returned, download the image asynchronously
                for urlString in urlStrings {
                    if let imageUrl = URL(string: urlString) {
                        group.enter()
                        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                            if let data = data, let img = UIImage(data: data) {
                                images.append(img)
                            }
                            group.leave()
                        }.resume()
                    }
                }

                // When all downloads are complete, return the images
                group.notify(queue: .main) {
                    completion(.success(images))
                }
            } catch {
                // Handle JSON parsing error
                completion(.failure(error))
            }
        }.resume()
    }
}
