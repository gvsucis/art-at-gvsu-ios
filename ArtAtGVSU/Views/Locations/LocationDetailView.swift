//
//  LocationDetail.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/15/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct LocationDetailView: View {
    let id: String
    let navigationTitle: String
    @State var data: Async<Location>

    init(id: String, navigationTitle: String, data: Async<Location> = .uninitialized) {
        self.id = id
        self.navigationTitle = navigationTitle
        self._data = State(initialValue: data)
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {
        VStack {
            switch data {
            case .loading:
                LoadingView()
            case .success(let location):
                LocationLoadedView(location: location)
            default:
                EmptyView()
            }
        }
        .background(Color.background)
        .navigationBarTitle(navigationTitle, displayMode: .inline)
        .onAppear(perform: fetchLocation)
    }


    func fetchLocation() {
        guard !data.isSuccess else { return }
        data = .loading
        Location.fetch(id: id) { location in
            data = .success(location)
        }
    }
}

private struct LocationLoadedView: View {
    let location: Location

    var body: some View {
        let isCompletelyEmpty = location.locations.isEmpty && location.artworks.isEmpty
        if isCompletelyEmpty {
            Text("locationDetail_Empty")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        List {
            if !location.locations.isEmpty {
                Section(header: Text("locationDetail_ChildLocations")) {
                    ForEach(location.locations, id: \.id) { childLocation in
                        NavigationLink(
                            destination: LocationDetailView(id: childLocation.id, navigationTitle: childLocation.name)
                        ) {
                            Text(childLocation.name)
                                .foregroundColor(Color(UIColor.label))
                        }
                    }
                }
            }

            if !location.artworks.isEmpty {
                Section(header: Text("locationDetail_Artworks")) {
                    ForEach(location.artworks, id: \.id) { artwork in
                        ArtworkDetailNavigationLink(artwork: artwork)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationLoadedView(
            location: Location(
                id: "2",
                name: "Allendale Campus",
                locations: [Location(id: "606", name: "Ground Floor (JHZ)")],
                artworks: [
                    Artwork(
                        id: "3272",
                        name: "Study (Fish)",
                        thumbnail: URL(string: "https://artgallery.gvsu.edu//admin//media//collectiveaccess//images//5//6//21942_ca_object_representations_media_5696_small.jpg")
                    )
                ]
            )
        )

        LocationLoadedView(location: Location(id: "50"))
            .preferredColorScheme(.dark)
            .previewDisplayName("Empty Building")
    }
}
