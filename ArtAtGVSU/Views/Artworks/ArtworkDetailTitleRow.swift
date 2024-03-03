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
    @State private var isFetchingARAsset = false

    var body: some View {
        HStack(alignment: .top) {
            Text(artwork.name)
                .detailHeading()
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            HStack(alignment: .bottom) {
                Button(action: shareArtwork) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color(UIColor.label))
                        .imageScale(.large)
                }
                if artwork.arDigitalAsset != nil {
                    Spacer()
                        .frame(width: 16)
                    Button(action: {
                        isFetchingARAsset = true

                        Task {
                            await showARAsset()
                            isFetchingARAsset = false
                        }
                    }) {
                        if isFetchingARAsset {
                            ProgressView()
                        } else {
                            Image(systemName: "camera.viewfinder")
                                .foregroundColor(Color(UIColor.label))
                                .imageScale(.large)
                        }
                    }
                    .disabled(isFetchingARAsset)
                    .frame(width: 24)
                }
                Spacer()
                    .frame(width: 16)
                Button(action: { favorite.toggle() }) {
                    Image(systemName: favorite.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(Color(UIColor.systemRed))
                        .imageScale(.large)
                }
            }
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

    func showARAsset() async {
        guard let arAssetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ARAssetVC") as? ARAssetViewController else {
            fatalError("ARAssetViewController not implemented in storyboard")
        }

        let asset = try! await ARAsset.getARResources(artwork: artwork)

        arAssetViewController.arAsset = asset
        arAssetViewController.modalPresentationStyle = .fullScreen

        if let root = UIApplication.shared.windows.first?.rootViewController{
            root.present(arAssetViewController, animated: true, completion: nil)
        }
    }
}

struct ARAssetVCView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> ARAssetViewController {

        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ARAssetVC") as? ARAssetViewController else {
            fatalError("ARAssetViewController not implemented in storyboard")
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: ARAssetViewController, context: Context) {
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
