//
//  LocationIndexView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/15/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct LocationIndexView: View {
    @StateObject private var viewModel = LocationIndexViewModel()

    var body: some View {
        ScrollView {
            LazyVStack {
                switch viewModel.data {
                case .success(let locations):
                    ForEach(locations) { location in
                        NavigationLink(destination: LocationDetailView(id: location.id, navigationTitle: location.name)) {
                            WideTitleCard(
                                title: location.name,
                                imageURL: location.mediaLargeURL
                            )
                        }
                        .buttonStyle(OpaqueButtonStyle())
                    }
                default:
                    LoadingView()
                }
            }
            .padding()
        }
        .background(Color.background)
        .navigationTitle("navigation_Campuses")
    }
}
