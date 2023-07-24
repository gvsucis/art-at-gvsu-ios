//
//  HomeLoadedView.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/25/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeLoadedView: View {
    let artworks: [Artwork]

    var body: some View {
        VStack(alignment: .leading) {
            RotatingFeaturedImage(artworks: artworks, featuredWork: featuredWork)
            BrowseLink(destination: FeaturedIndexView(artworks: artworks), title: "home_featuredIndex")
            BrowseLink(destination: LocationIndexView(), title: "home_browseCampuses")
            Spacer()
        }
        .padding()
    }
    
    var featuredWork: Artwork {
        return artworks.randomElement()!
    }
}

struct BrowseLink<V: View>: View {
    let destination: V
    let title: LocalizedStringKey

    var body: some View {
        VStack {
            NavigationLink(destination: destination) {
                HStack{
                    Text(title)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .contentShape(Rectangle())
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
            .buttonStyle(PlainButtonStyle())
            Divider()
        }
    }
}

struct RotatingFeaturedImage: View {
    let artworks: [Artwork]
    let featuredWork: Artwork

    var body: some View {
        NavigationLink(
            destination: ArtworkDetailRepresentable(artworkID: featuredWork.id)
                .navigationBarTitleDisplayMode(.inline)
        ) {
            GeometryReader { geo in
                WebImage(url: featuredWork.mediaLarge)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: geo.size.width)
                    .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
            }
            .aspectRatio(1 / 1, contentMode: .fit)
            .overlay(FeaturedTitle(artwork: featuredWork))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3)
        }
        .buttonStyle(OpaqueButtonStyle())
    }
}

struct FeaturedTitle: View {
    var artwork: Artwork

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
                Text(artwork.name)
                    .font(.title2)
                    .foregroundColor(.offWhite)
                    .bold()
                if !artwork.artistName.isEmpty {
                    Text(artwork.artistName)
                }
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

struct HomeLoadedView_Previews: PreviewProvider {
    static let artworks = [
        Artwork(
            id: "12853",
            mediaRepresentations: [
                "https:/artgallery.gvsu.edu/admin/media/collectiveaccess/images/1/4/4/5337_ca_object_representations_media_14448_large.jpg"
            ].map { URL(string: $0)! },
            name: "Duo (Two)",
            artistName: "Judith Brown",
            historicalContext: "Judith Brown employed scrap metal in much of her work, ranging from small religious ceremonial objects such as a Hanukkah lamp in the collection of The Jewish Museum, to monumental sculptures and public art projects like the installation commissioned for the Federal Courthouse building in Trenton, New Jersey.",
            workDescription: "",
            workDate: "ca. 1985",
            workMedium: "Painted and welded scrap metal",
            location: "3rd Floor (JHZ)",
            identifier: "2013.68.7",
            creditLine: "A Gift of the Stuart and Barbara Padnos Foundation",
            mediaLarge: URL(string: "https://artgallery.gvsu.edu//admin//media//collectiveaccess//images//2//42600_ca_object_representations_media_203_large.jpg")!
        )
    ]

    static var previews: some View {
        HomeLoadedView(artworks: artworks)
    }
}
