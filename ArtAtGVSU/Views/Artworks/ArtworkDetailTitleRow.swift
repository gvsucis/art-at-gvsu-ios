//
//  ArtworkDetailTitleRow.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 7/18/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct ArtworkDetailTitleRow: View {
    let artwork: Artwork
    @ObservedObject var favorite: FavoritesStore
    @State private var isActive = false

    var body: some View {
        HStack(alignment: .top) {
            Text(artwork.name)
                .detailHeading()
                .fixedSize(horizontal: false, vertical: true)

            if artwork.arDigitalAsset != nil || artwork.id == "32481" {
                Group {
                    Spacer()
                    Button(action: {
                        isActive = true
                    }) {
                        Image(systemName: "camera.viewfinder")
                            .foregroundColor(Color(UIColor.label))
                            .imageScale(.large)
                    }.disabled(isActive)
                        .sheet(isPresented: $isActive) {
                            ARSplashView(artwork: artwork)
                        }
                }
            }
//            } else {
//                EmptyView()
//            }
            Spacer()
                .frame(width: 16)
            Button(action: shareArtwork) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color(UIColor.label))
                    .imageScale(.large)
            }
            Spacer()
                .frame(width: 16)
            Button(action: { favorite.toggle() }) {
                Image(systemName: favorite.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(Color(UIColor.systemRed))
                    .imageScale(.large)
            }
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        }
    }

    func shareArtwork() {
        let activity = UIActivityViewController(
            activityItems: [Links.artworkDetail(id: "\(artwork.id)")],
            applicationActivities: nil
        )
        if let root = UIApplication.shared.windows.first?.rootViewController{
            root.present(activity, animated: true, completion: nil)
        }
    }
}

struct ArtworkDetailTitleRow_Previews: PreviewProvider {
    static let artwork = Artwork(id: "17", name: "My Artwork")
    static let artworkLongName = Artwork(id: "17", name: "My Artwork with a Long Name that Could wrap")

    static var previews: some View {
        ArtworkDetailTitleRow(
            artwork: artwork,
            favorite: FavoritesStore(artworkID: artwork.id)
        )
        .preferredColorScheme(.dark)

        ArtworkDetailTitleRow(
            artwork: artwork,
            favorite: FavoritesStore(artworkID: artwork.id)
        )

        ArtworkDetailTitleRow(
            artwork: artworkLongName,
            favorite: FavoritesStore(artworkID: artworkLongName.id)
        )
    }
}
