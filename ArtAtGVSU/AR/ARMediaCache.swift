//
//  ARMediaCache.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/19/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import Foundation

/// Downloads AR media on demand and caches videos on disk, bounding the cache
/// with least-recently-used eviction so the gallery's videos never all sit on
/// disk at once. Reference images are fetched as raw bytes and never persisted —
/// the caller turns them straight into `ARReferenceImage`s.
actor ARMediaCache {
    static let shared = ARMediaCache()

    enum CacheError: Error {
        case noDocumentsDirectory
        case downloadFailed(URL)
    }

    private let fileManager = FileManager.default
    private let session: URLSession
    private let directoryName = "ARMedia"
    private let maxCachedVideos: Int

    init(session: URLSession = .shared, maxCachedVideos: Int = 8) {
        self.session = session
        self.maxCachedVideos = maxCachedVideos
    }

    /// A local file URL for `remoteURL`, downloading it if it isn't cached.
    /// Re-touches the file so the most-recently-viewed videos survive eviction.
    func localURL(for remoteURL: URL) async throws -> URL {
        let directory = try cacheDirectory()
        let destination = directory.appendingPathComponent(remoteURL.lastPathComponent)

        if fileManager.fileExists(atPath: destination.path) {
            touch(destination)
            return destination
        }

        try await download(remoteURL, to: destination)
        touch(destination)
        try prune()
        return destination
    }

    /// Raw bytes for a reference image. Not persisted.
    func data(for url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        try validate(response, for: url)
        return data
    }

    // MARK: - Private

    private func cacheDirectory() throws -> URL {
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw CacheError.noDocumentsDirectory
        }
        let directory = documents.appendingPathComponent(directoryName, isDirectory: true)
        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        return directory
    }

    private func download(_ remoteURL: URL, to destination: URL) async throws {
        let (temporaryURL, response) = try await session.download(from: remoteURL)
        try validate(response, for: remoteURL)

        if fileManager.fileExists(atPath: destination.path) {
            try fileManager.removeItem(at: destination)
        }
        try fileManager.moveItem(at: temporaryURL, to: destination)
    }

    private func validate(_ response: URLResponse, for url: URL) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard 200..<300 ~= http.statusCode else {
            throw CacheError.downloadFailed(url)
        }
    }

    private func touch(_ url: URL) {
        try? fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: url.path)
    }

    /// Drops the least-recently-touched videos once the cache exceeds its cap.
    private func prune() throws {
        let directory = try cacheDirectory()
        let key: URLResourceKey = .contentModificationDateKey
        let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: [key])
        guard files.count > maxCachedVideos else { return }

        let sorted = files.sorted { lhs, rhs in
            modificationDate(of: lhs) < modificationDate(of: rhs)
        }
        for file in sorted.prefix(files.count - maxCachedVideos) {
            try? fileManager.removeItem(at: file)
        }
    }

    private func modificationDate(of url: URL) -> Date {
        (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
    }
}
