//
//  ArtworkDetailVideoPlaceholder.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/1/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtworkMultimediaThumbnail: View {
    var url: URL?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
            WebImage(url: url)
                .resizable()
                .scaledToFill()
                .overlay(DarkenOverlay())
            Image(systemName: "play.circle")
                .resizable()
                .foregroundColor(.icon)
                .frame(width: 32, height: 32)
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct DarkenOverlay: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.black.opacity(0.2))
        }
    }
}

struct ArtworkDetailVideoPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://artgallery.gvsu.edu//admin//media//collectiveaccess//images//1//1//9//20822_ca_object_representations_media_11909_small.jpg")
        ArtworkMultimediaThumbnail(url: url)
    }
}
