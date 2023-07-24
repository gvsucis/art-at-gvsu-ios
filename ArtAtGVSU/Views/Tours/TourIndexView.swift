//
//  TourIndexView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct TourIndexView: View {
    @State var data: Async<[Tour]> = .loading

    var body: some View {
        VStack {
            switch data {
            case .success(let tours):
                TourIndexLoadedView(tours: tours)
            case .loading:
                LoadingView()
            default:
                EmptyView()
            }
        }
        .navigationBarTitle("navigation_Tours", displayMode: .large)
        .background(Color.background)
        .onAppear(perform: fetchTours)
    }

    func fetchTours() {
        guard !data.isSuccess else { return }
        Tour.fetchAll { tours in
            self.data = .success(tours)
        }
    }
}

struct TourIndexLoadedView: View {
    let tours: [Tour]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(tours, id: \.id) { tour in
                    NavigationLink(
                        destination:
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
}
