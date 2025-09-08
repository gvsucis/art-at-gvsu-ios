//
//  Tour.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation
import Web

struct Tour: Identifiable {
    var id: String
    var name: String = ""
    var mediaIcon: URL? = nil
    var mediaLargeURL: URL? = nil
    var mediaMedium: URL? = nil
    var mediaSmall: URL? = nil
    var tourStopIDs: [String] = []
}

extension Tour {
    func fetchTourStops(transport: Transport = URLSession.shared, _ completion: @escaping ([TourStop]) -> Void) {
        Task {
            await withTaskGroup(of: TourStopDetail?.self) { group in
                for id in tourStopIDs {
                    group.addTask{
                        return await fetchTourStop(id: id, transport: transport)
                    }
                }

                let details = await group.reduce(into: [TourStopDetail?]()) { $0.append($1) }

                let stops = details
                    .filter { !($0?.stop_objects_id ?? "").isEmpty }
                    .compactMap { $0?.toDomainModel()  }
                    .filter { $0.location != nil }
                    .sorted { $0.name < $1.name }

                completion(stops)
            }
        }
    }

    private func fetchTourStop(id: String, transport: Transport) async -> TourStopDetail? {
        return await withCheckedContinuation { continuation in
            ArtGalleryClient(transport: transport).fetchTourStop(id: id) { result in
                switch result {
                case .success(let detail):
                    continuation.resume(returning: detail)
                case .failure(_):
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    static func fetchAll(transport: Transport = URLSession.shared, _ completion: @escaping ([Tour]) -> Void) {
        ArtGalleryClient(transport: transport).fetchTours { result in
            switch result {
            case .success(let tours):
                completion(mapSort(tours))
            case .failure(_):
                break;
            }
        }
    }

    private static func mapSort(_ tours: TourSearchResult?) -> [Tour] {
        guard let tours = tours else { return [] }
        return tours.details
            .map { $0.toDomainModel() }
            .sorted { $0.id < $1.id }
    }
}

extension TourSearchDetail {
    func toDomainModel() -> Tour {
        return Tour(
            id: String(tour_id!),
            name: tour_name ?? "",
            mediaLargeURL: optionalURL(media_large_url),
            tourStopIDs: tour_stops_id?.split(separator: ";").map { String($0) } ?? []
        )
    }
}
