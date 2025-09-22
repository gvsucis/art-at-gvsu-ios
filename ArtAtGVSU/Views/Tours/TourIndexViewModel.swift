//
//  TourIndexViewModel.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 9/8/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//

import Foundation

class TourIndexViewModel: ObservableObject {
    @Published var data: Async<[Tour]> = .loading

    init() {
        fetchTours()
    }

    private func fetchTours() {
        guard !data.isSuccess else { return }
        Tour.fetchAll { tours in
            DispatchQueue.main.async {
                self.data = .success(tours)
            }
        }
    }
}
