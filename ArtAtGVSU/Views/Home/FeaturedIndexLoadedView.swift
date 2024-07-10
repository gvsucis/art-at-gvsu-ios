//
//  FeaturedIndexLoadedView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/27/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct FeaturedIndexLoadedView: View {
    let artworks: [Artwork]

    var body: some View {
        List {
            ForEach(artworks, id: \.id) { artwork in
                ArtworkDetailNavigationLink(artwork: artwork)
                    .listRowBackground(Color.background)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.background)
    }
}

struct FeaturedIndexView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedIndexLoadedView(
            artworks: [
                Artwork(
                    id: "3818",
                    name: "Dutch Woodcutter",
                    thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/56084_ca_object_representations_media_17364_small.jpg")
                )
            ]
        )
    }
}
