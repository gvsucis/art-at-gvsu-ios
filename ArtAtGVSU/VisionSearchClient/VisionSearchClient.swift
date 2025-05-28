//
//  VisionSearchClient.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/26/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//
import Foundation
import Web

struct VisionSearchClient {
    let baseURL: String
    let transport: Transport

    init(transport: Transport = URLSession.shared, baseURL: String = Properties.shared.vision_search_base_url) {
        self.transport = transport
        self.baseURL = baseURL
    }


    func search(image: Data) async -> Result<SearchResponse?, Error> {
        var multipart = MultipartRequest()

        multipart.add(
            key: "image",
            mimeType: "image/jpeg",
            fileData: image
        )

        let url = URL(string: "\(baseURL)/search")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = multipart.httpBody

        do {
            let (_, data) = try await transport.send(request: request, resultType: SearchResponse.self)

            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
