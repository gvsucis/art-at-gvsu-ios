//
//  ArtworkDetailNavigationLink.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct ArtworkDetailNavigationLink: View {
    let artwork: Artwork

    var body: some View {
        NavigationLink(destination: ArtworkDetailRepresentable(artworkID: artwork.id)) {
            ThumbnailTitleRow(
                title: artwork.name,
                thumbnail: artwork.thumbnail
            )
        }
    }
}

struct ArtworkDetailNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkDetailNavigationLink(artwork: Artwork(
            id: "3818",
            name: "Dutch Woodcutter",
            thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/56084_ca_object_representations_media_17364_small.jpg")
        ))
    }
}
