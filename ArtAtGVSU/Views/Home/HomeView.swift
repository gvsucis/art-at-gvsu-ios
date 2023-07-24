//
//  FeaturedIndexView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var data: Async<[Artwork]> = .uninitialized

    var body: some View {
        VStack {
            switch data {
            case .success(let artworks):
                HomeLoadedView(artworks: artworks)
            case .loading:
                LoadingView()
            default:
                EmptyView()
            }
        }
        .onAppear(perform: fetchArtworks)
        .background(Color.background)
    }

    func fetchArtworks() {
        if data.isLoading || data.isSuccess { return }

        data = .loading
        Artwork.featured { artworks in
            data = .success(artworks)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(data: .success(artworks))

        HomeView()
    }

    static let artworks = [
        Artwork(
            id: "12853",
            mediaRepresentations: [
                "https:/artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/5337_ca_object_representations_media_14448_large.jpg"
            ].map { URL(string: $0)! },
            name: "Duo (Two)",
            artistName: "Judith Brown",
            historicalContext: "Judith Brown employed scrap metal in much of her work, ranging from small religious ceremonial objects such as a Hanukkah lamp in the collection of The Jewish Museum, to monumental sculptures and public art projects like the installation commissioned for the Federal Courthouse building in Trenton, New Jersey.",
            workDescription: "",
            workDate: "ca. 1985",
            workMedium: "Painted and welded scrap metal",
            location: "3rd Floor (JHZ)",
            identifier: "2013.68.7",
            creditLine: "A Gift of the Stuart and Barbara Padnos Foundation",
            mediaLarge: URL(string: "https://artgallery.gvsu.edu//admin//media//collectiveaccess//images//2//42600_ca_object_representations_media_203_large.jpg")!
        )
    ]

}
