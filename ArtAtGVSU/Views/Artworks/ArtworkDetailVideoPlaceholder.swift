//
//  ArtworkDetailVideoPlaceholder.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/1/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtworkDetailVideoPlaceholder: View {
    var url: URL?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
            WebImage(url: url)
                .resizable()
                .scaledToFill()
                .blur(radius: 5.0, opaque: true)
                .overlay(DarkenOverlay())
            Image(systemName: "play.circle")
                .resizable()
                .foregroundColor(.icon)
                .frame(width: 64, height: 64)
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
        ArtworkDetailVideoPlaceholder(url: url)
    }
}
