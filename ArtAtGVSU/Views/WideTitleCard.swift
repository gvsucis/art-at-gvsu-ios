//
//  WideTitleCard.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 6/22/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct WideTitleCard: View {
    var title: String
    var imageURL: URL?
    
    var body: some View {
        GeometryReader { geo in
            WebImage(url: imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: geo.size.width)
                .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
        .aspectRatio(3 / 2, contentMode: .fit)
        .overlay(CardTitle(text: title))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct CardTitle: View {
    var text: String

    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.black.opacity(0.6), Color.black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle().fill(gradient)
            VStack(alignment: .leading) {
                Text(text)
                    .font(.title2)
                    .foregroundColor(.offWhite)
                    .bold()
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}


struct WideTitleCard_Previews: PreviewProvider {
    static var previews: some View {
        WideTitleCard(
            title: "Detroit Regional Center",
            imageURL: URL(
                string: "https://artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/6/3/892_ca_object_representations_media_16392_medium.jpg") 
        )
        .previewLayout(.sizeThatFits)
        .background(Color.background)
    }
}
