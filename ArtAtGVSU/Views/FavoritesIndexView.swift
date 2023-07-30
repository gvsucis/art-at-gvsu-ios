//
//  FavoritesIndexView.swift
//  ArtAtGVSU
//
//  Created by jocmp on 7/30/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct FavoritesIndexView: View {
    @State var favorites: [Favorite] = []
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(favorites) { favorite in
                        NavigationLink(destination: ArtworkDetailRepresentable(artworkID: favorite.artworkID)) {
                            WideTitleCard(title: favorite.artworkName, imageURL: favorite.imageURL)
                        }
                        .buttonStyle(OpaqueButtonStyle())
                    }
                }
                .padding()
            }
        }
        .background(Color.background)
        .onAppear() {
            favorites = FavoritesStore.favorites()
        }
    }
}
