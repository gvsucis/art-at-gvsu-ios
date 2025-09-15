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
        Button(action: {
            presentArtworkDetail()
        }) {
            ThumbnailTitleRow(
                title: artwork.name,
                thumbnail: artwork.thumbnail
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func presentArtworkDetail() {
        ArtworkDetailController.presentArtworkDetail(artworkID: artwork.id)
    }
}
