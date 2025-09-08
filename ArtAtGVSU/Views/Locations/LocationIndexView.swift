//
//  LocationIndexView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/15/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct LocationIndexView: View {
    @State var data: Async<[Location]> = .loading

    var body: some View {
        VStack {
            switch data {
            case .success(let locations):
                LocationIndexLoadedView(locations: locations)
            case .loading:
                LoadingView()
            default:
                EmptyView()
            }
        }
        .navigationTitle("navigation_Campuses")
        .toolbarTitleDisplayMode(.inlineLarge)
        .background(Color.background)
        .onAppear(perform: fetchCampuses)
    }

    func fetchCampuses() {
        guard !data.isSuccess else { return }
        Location.fetchAllCampuses { locations in
            self.data = .success(locations)
        }
    }
}

struct LocationIndexLoadedView: View {
    let locations: [Location]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(locations, id: \.id) { location in
                    NavigationLink(destination: LocationDetailView(id: location.id, navigationTitle: location.name)) {
                        WideTitleCard(
                            title: location.name,
                            imageURL: location.mediaLargeURL
                        )
                    }
                    .buttonStyle(OpaqueButtonStyle())
                }
            }
            .padding()
        }
    }
}

struct LocationIndexView_Previews: PreviewProvider {
    static let locations = [
        Location(
            id: "453",
            name: "Detroit Regional Center",
            mediaMediumURL: URL(
                string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/6/3/892_ca_object_representations_media_16392_medium.jpg")
        )
    ]

    static var previews: some View {
        LocationIndexView(data: .success(locations))
            .previewDisplayName("Index On Success")

        LocationIndexView(data: .loading)
            .previewDisplayName("Index On Load")
    }
}
