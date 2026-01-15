//
//  SearchResultCard.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 1/11/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchResultCard: View {
    let title: String
    let subtitle: String
    let imageURL: URL?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                WebImage(url: imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
            }
            .frame(width: 140, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(UIColor.label))
                    .lineLimit(2)

                Text(subtitle.isEmpty ? " " : subtitle)
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .lineLimit(1)
            }
            .frame(height: 52, alignment: .top)
        }
        .frame(width: 140, height: 208)
    }
}

struct SearchArtistCard: View {
    let name: String
    let lifeDates: String
    let imageURL: URL?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                Text(initials)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                if let imageURL = imageURL {
                    WebImage(url: imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 140, height: 140)
                }
            }
            .frame(width: 140, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(UIColor.label))
                    .lineLimit(2)

                Text(lifeDates.isEmpty ? " " : lifeDates)
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .lineLimit(1)
            }
            .frame(height: 52, alignment: .top)
        }
        .frame(width: 140, height: 208)
    }

    private var initials: String {
        name.prefix(2).uppercased()
    }
}

struct SearchResultCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultCard(
            title: "Dutch Woodcutter",
            subtitle: "Mathias J. Alten",
            imageURL: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/56084_ca_object_representations_media_17364_small.jpg")
        )
        .previewLayout(.sizeThatFits)
        .padding()

        SearchArtistCard(
            name: "Mathias J. Alten",
            lifeDates: "1871-1938",
            imageURL: nil
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
