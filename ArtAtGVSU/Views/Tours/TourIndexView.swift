//
//  TourIndexView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct TourIndexView: View {
    @StateObject private var viewModel = TourIndexViewModel()

    var body: some View {
        ScrollView {
            LazyVStack {
                switch viewModel.data {
                case .success(let tours):
                    TourIndexLoadedView(tours: tours)
                default:
                    LoadingView()
                }
            }
        }
        .background(Color.background)
        .navigationTitle("navigation_Tours")
    }
}

struct TourIndexLoadedView: View {
    let tours: [Tour]

    var body: some View {
        ScrollView {
            ForEach(tours) { tour in
                NavigationLink(destination:
                        TourDetailView(tour: tour)
                          .navigationBarTitle(tour.name, displayMode: .inline)
                ) {
                    WideTitleCard(
                        title: tour.name,
                        imageURL: tour.mediaLargeURL
                    )
                }
                .buttonStyle(OpaqueButtonStyle())
            }
        }
        .padding()
    }
}
