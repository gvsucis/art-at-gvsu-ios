//
//  MultipartRequest.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/26/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//
import Foundation

struct MultipartRequest {
    let boundary: String

    private let separator: String = "\r\n"
    private var data: Data

    init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self.data = .init()
    }

    private mutating func appendBoundarySeparator() {
        data.append("--\(boundary)\(separator)")
    }

    private mutating func appendSeparator() {
        data.append(separator)
    }

    private func disposition(_ key: String) -> String {
        "Content-Disposition: form-data; name=\"\(key)\""
    }

    mutating func add(
        key: String,
        value: String
    ) {
        appendBoundarySeparator()
        data.append(disposition(key) + separator)
        appendSeparator()
        data.append(value + separator)
    }

    mutating func add(
        key: String,
        mimeType: String,
        fileData: Data
    ) {
        appendBoundarySeparator()
        data.append(disposition(key) + "; filename=\"image\"" + separator)
        data.append("Content-Type: \(mimeType)" + separator + separator)
        data.append(fileData)
        appendSeparator()
    }

    var httpContentTypeHeadeValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    var httpBody: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--")
        return bodyData
    }
}
