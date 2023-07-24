//
//  ArtworkDetailRelatedObjects.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/2/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct ArtworkDetailRelatedWorks: View {
    var relatedWorks: [Artwork]
    var presentArtwork: (_ artworkID: String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("artworkDetail_RelatedWorks"))
                .font(.title3)
                .foregroundColor(Color(UIColor.secondaryLabel))
            ForEach(relatedWorks, id: \.id) { work in
                Button(action: { presentArtwork(work.id) }) {
                    ThumbnailTitleRow(title: work.name, thumbnail: work.thumbnail)
                }
                .padding(8)
            }
        }
    }
}


struct ArtworkDetailRelatedWorks_Previews: PreviewProvider {
    static let relatedWorks: [Artwork] = [
        Artwork(
            id: "3817",
            name: "Dutchman with Canal Boat",
            thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/5/6/2171_ca_object_representations_media_15698_small.jpg")
        ),
        Artwork(
            id: "3818",
            name: "Dutch Woodcutter",
            thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/56084_ca_object_representations_media_17364_small.jpg")
        )
    ]

    static var previews: some View {
        ArtworkDetailRelatedWorks(
            relatedWorks: relatedWorks,
            presentArtwork: { _ in }
        ).background(Color.background)
    }
}
