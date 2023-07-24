//
//  ArtistDetailBiographyView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct ArtistDetailBiographyView: View {
    var artist: Artist

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(artist.name)
                    .detailHeading()
                    .fixedSize(horizontal: false, vertical: true)
                if hasLifeDatesSummary {
                    Text(artist.lifeDatesSummary)
                }
                if hasNationality {
                    Text(artist.nationality)
                }
                DetailDivider()
                if !artist.biography.isEmpty {
                    Text(artist.biography)
                        .fixedSize(horizontal: false, vertical: true)
                    DetailDivider()
                }
            }
        }
    }

    var hasLifeDatesSummary: Bool {
        !artist.lifeDatesSummary.isEmpty
    }

    var hasNationality: Bool {
        !artist.nationality.isEmpty
    }
}

struct ArtistDetailBiographyView_Previews: PreviewProvider {
    static let alten = Artist(
        id: "637",
        name: "Mathias Joseph Alten",
        lifeDatesSummary: "1871-1938",
        nationality: "German American",
        biography: "Alten's view of Grand Rapids captured the expansion and development of a city through images including its downtown streets, Reeds Lake and Alten's own backyard.\r\n\r\nAlten, a painter of much wider acclaim than the boundaries of this community, chose to make his home, raise his family, and paint here the majority of his life."
    )

    static let partialAlten = Artist(
        id: "637",
        nationality: "German American"
    )

    static var previews: some View {
        ArtistDetailBiographyView(artist: alten)
            .previewDevice("iPhone 8")
            .previewLayout(.sizeThatFits)

        ArtistDetailBiographyView(artist: partialAlten)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Partial Details")

        ArtistDetailBiographyView(artist: Artist(id: "637", biography: alten.biography))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Biography only")
    }
}
