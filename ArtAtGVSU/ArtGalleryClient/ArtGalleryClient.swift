//
//  ArtGalleryClient.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 4/25/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation
import Web

struct ArtGalleryClient {
    let baseURL: String
    let transport: Transport

    init(transport: Transport = URLSession.shared, baseURL: String = Properties.shared.art_gallery_base_url) {
        self.transport = transport
        self.baseURL = baseURL
    }

    func fetchFeaturedArt(completion: @escaping (Result<FeaturedArtResult?, Error>) -> Void) {
        sendRequest(resource: "objectSearch?q=featured_art", completion: completion)
    }

    func fetchObjectDetail(id: String, completion:  @escaping (Result<ObjectDetail?, Error>) -> Void) {
        sendRequest(resource: "objectDetail?id=\(id)", completion: completion)
    }

    func fetchEntityDetail(id: String, completion:  @escaping (Result<EntityDetail?, Error>) -> Void) {
        sendRequest(resource: "entityDetail?id=\(id)", completion: completion)
    }

    func fetchLocationDetail(id: String, completion:  @escaping (Result<LocationDetail?, Error>) -> Void) {
        sendRequest(resource: "locationDetail?id=\(id)", completion: completion)
    }

    func fetchCampuses(completion: @escaping (Result<CampusSearchResult?, Error>) -> Void) {
        sendRequest(resource: "locationcampusSearch?q=*", completion: completion)
    }

    func fetchTours(completion: @escaping (Result<TourSearchResult?, Error>) -> Void) {
        sendRequest(resource: "tourSearch?q=*", completion: completion)
    }

    func fetchTourStop(id: String, completion: @escaping (Result<TourStopDetail?, Error>) -> Void) {
        sendRequest(resource: "tourstopsDetail?id=\(id)", completion: completion)
    }

    func searchEntities(term: String, limit: Int? = nil, completion:  @escaping (Result<EntitySearchResult?, Error>) -> Void) {
        var resource = "entitySearch?q=\(sanitizeTerm(term))"
        if let limit = limit {
            resource += "&limit=\(limit)"
        }
        sendRequest(resource: resource, completion: completion)
    }

    func searchObjects(term: String, limit: Int? = nil, completion:  @escaping (Result<ObjectSearchResult?, Error>) -> Void) {
        var resource = "objectSearch?q=\(sanitizeTerm(term))"
        if let limit = limit {
            resource += "&limit=\(limit)"
        }
        sendRequest(resource: resource, completion: completion)
    }

    func downloadFile(_ url: URL, path: URL, completion: @escaping (URL, Error?) -> Void) {
        let downloadTask = URLSession.shared.downloadTask(with: url) {
            urlOrNil, responseOrNil, errorOrNil in
            if errorOrNil != nil {
                completion(url, errorOrNil)
                return
            }


            guard let fileURL = urlOrNil else { return }
            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: true)

                try FileManager.default.moveItem(at: fileURL, to: path)
                completion(path, nil)
            } catch {
                print ("file error: \(errorOrNil)")
                completion(url, errorOrNil)
            }
        }
        downloadTask.resume()
    }

    private func sendRequest<T: Decodable>(resource: String, completion:  @escaping (Result<T?, Error>) -> Void) {
        let endpoint = "\(baseURL)/\(resource)"
        transport.send(request: URLRequest(url: URL(string: endpoint)!), resultType: T.self) { result in
            switch result {
            case .success(let (_, successResult)):
                completion(.success((successResult)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func sanitizeTerm(_ term: String) -> String {
        let sanitizedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return sanitizedTerm ?? ""
    }
}
