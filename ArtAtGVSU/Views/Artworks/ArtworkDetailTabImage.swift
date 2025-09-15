//
//  TabImage.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/2/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct ArtworkDetailTabImage: View {
    var url: URL
    var onClick: () -> Void
    @State var image: UIImage? = nil

    var body: some View {
        ZStack {
            Color.black
            if let image = image {
                Image(uiImage: image)
                    .centerFilled()
                    .overlay(TextOverlay())
            }
        }
        .onTapGesture(perform: onClick)
        .onAppear(perform: fetchImage)
    }

    private func fetchImage() {
        RemoteImage.fetch(url: url) { image in
            self.image = image
        }
    }
}

/**
 * https://old.reddit.com/r/SwiftUI/comments/1d50ud2/images_spilling_over_in_tabview/l6j1cg3/
 */
private extension Image {
    func centerFilled() -> some View {
        Color.clear
        .overlay(
            self
            .resizable()
            .scaledToFill()
        )
        .clipped()
    }
}

struct TabImage_Previews: PreviewProvider {

    static var previews: some View {
        ArtworkDetailTabImage(
            url: URL(string: "https:/artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/5337_ca_object_representations_media_14448_large.jpg")!,
            onClick: {}
        )
    }
}
