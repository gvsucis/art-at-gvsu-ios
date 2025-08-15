//
//  ArtworkMultimediaRow.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/15/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//
import SwiftUI

struct ArtworkMultimediaRow: View {
    let mediaItems: [SecondaryMedia]
    let onClick: (URL) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("artworkDetail_Multimedia")
                .font(.title3)
                .foregroundColor(Color(UIColor.secondaryLabel))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(mediaItems.enumerated()), id: \.offset) { index, media in
                        Button(action: {
                            onClick(media.url)
                        }) {
                            ArtworkMultimediaThumbnail(url: media.thumbnailURL)
                                .frame(width: 160, height: 120)
                                .aspectRatio(4/3, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

struct ArtworkMultimediaRow_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedia = [
            SecondaryMedia(
                url: URL(string: "https://example.com/video1.mp4")!,
                thumbnailURL: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/1/9/20822_ca_object_representations_media_11909_small.jpg")!
            ),
            SecondaryMedia(
                url: URL(string: "https://example.com/video2.mp4")!,
                thumbnailURL: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/1/9/20822_ca_object_representations_media_11909_small.jpg")!
            ),
            SecondaryMedia(
                url: URL(string: "https://example.com/video3.mp4")!,
                thumbnailURL: URL(string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/1/9/20822_ca_object_representations_media_11909_small.jpg")!
            )
        ]

        ArtworkMultimediaRow(mediaItems: sampleMedia) { url in
            print("Tapped media: \(url)")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
