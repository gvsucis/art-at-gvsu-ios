//
//  ThumbnailTitleRow.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/16/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ThumbnailTitleRow: View {
    var title: String
    var thumbnail: URL?

    var body: some View {
        VStack {
            HStack(spacing: 16) {
                WebImage(url: thumbnail)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 48, height: 48)
                    .overlay(Circle().stroke(Color.thumbnailOutline, lineWidth: 2))
                Text(title)
                    .foregroundColor(Color(UIColor.label))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
    }
}

struct ThumbnailTitleRow_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailTitleRow(
            title: "Dutch Woodcutter",
            thumbnail: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/56084_ca_object_representations_media_17364_small.jpg")
        )
        .previewLayout(.sizeThatFits)
    }
}
