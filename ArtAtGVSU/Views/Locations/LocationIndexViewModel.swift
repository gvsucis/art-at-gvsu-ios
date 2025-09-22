//
//  LocationIndexViewModel.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 9/12/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import Foundation

class LocationIndexViewModel: ObservableObject {
    @Published var data: Async<[Location]> = .loading

    init() {
        fetchCampuses()
    }

    private func fetchCampuses() {
        guard !data.isSuccess else { return }
        Location.fetchAllCampuses { locations in
            DispatchQueue.main.async {
                self.data = .success(locations)
            }
        }
    }
}
