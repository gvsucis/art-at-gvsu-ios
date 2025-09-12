//
//  ArtistDetailView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct ArtistDetailView: View {
    let id: String
    @State var data: Async<Artist> = .uninitialized

    var body: some View {
        VStack {
            switch data {
            case .success(let artist):
                BiographyAndArtworks(artist: artist)
            case .loading:
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            default:
                EmptyView()
            }
        }
        .onAppear(perform: fetchArtist)
    }

    func fetchArtist() {
        guard !data.isSuccess else { return }
        data = .loading
        Artist.fetch(id: id) { artist in
            data = .success(artist)
        }
    }
}

private struct BiographyAndArtworks: View {
    let artist: Artist

    var body: some View {
        ScrollView {
            ArtistDetailBiographyView(artist: artist)
                .padding()
            LazyVStack {
                ForEach(artist.relatedWorks, id: \.id) { artwork in
                    ArtworkDetailNavigationLink(artwork: artwork)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
        }
    }
}

struct ArtistDetailView_Previews: PreviewProvider {
    static let artist = Artist(
        id: "1415",
        name: "Mathias J. Alten",
        biography: "A word or two.\nOr a paragraph about an artist.",
        relatedWorks: [
            Artwork(
                id: "3817",
                name: "Dutchman with Canal Boat",
                thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/5/6/2171_ca_object_representations_media_15698_small.jpg")
            )
        ]
    )

    static var previews: some View {
        ArtistDetailView(
            id: "1415",
            data: .success(artist)
        )

        ArtistDetailView(
            id: "1415",
            data: .loading
        )
    }
}
