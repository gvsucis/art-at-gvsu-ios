import SDWebImageSwiftUI
//
//  VisionImageList.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/26/25.
//  Copyright © 2025 Applied Computing Institute. All rights reserved.
//
import SwiftUI

struct VisionImageList: View {
    var images: [ImageResult]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(images) { image in
                    GeometryReader { geo in
                        Button(action: { ArtworkDetailController.present(artworkID: image.object_id) }) {
                            WebImage(url: image.imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .aspectRatio(contentMode: .fit)
                }
            }
            .padding()
        }
        .background(Color.background)
    }
}

struct VisionImageList_Previews: PreviewProvider {
    static var previews: some View {
        VisionImageList(
            images: [
                ImageResult(
                    object_id: "10500",
                    image_url:
                        "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/89943_ca_object_representations_media_17360_large.jpg"
                ),
                ImageResult(
                    object_id: "3845",
                    image_url:
                        "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/5/7/26285_ca_object_representations_media_15729_large.jpg"
                ),
                ImageResult(
                    object_id: "12280",
                    image_url:
                        "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/5/7/54050_ca_object_representations_media_15714_large.jpg"
                ),
                ImageResult(
                    object_id: "16294",
                    image_url:
                        "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/8/5/73146_ca_object_representations_media_18593_large.jpg"
                ),
                ImageResult(
                    object_id: "15581",
                    image_url:
                        "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/2/49466_ca_object_representations_media_17228_large.jpg"
                ),
                ImageResult(
                    object_id: "25840",
                    image_url:
                        "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/3/8/6/8764_ca_object_representations_media_38697_large.jpg"
                ),
                ImageResult(
                    object_id: "3841",
                    image_url:
                        "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/7/3/64691_ca_object_representations_media_17375_large.jpg"
                ),
            ]
        )
    }
}
