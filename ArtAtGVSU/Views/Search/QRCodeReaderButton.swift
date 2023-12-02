//
//  QRCodeReaderButton.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 12/1/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct QRCodeReaderButton: View {
    @State private var showModal = false
    @State private var artworkID: String? = nil
    var onArtworkResult: () -> Void = {}
    @State var canNavigateToArtwork = false

    var body: some View {
        ZStack {
            NavigationLink(
                destination: ArtworkDetailRepresentable(artworkID: artworkID)
                    .navigationBarTitleDisplayMode(.inline),
                isActive: $canNavigateToArtwork
            ) {
                EmptyView()
            }
            Button(action: openModal) {
                Image(systemName: "qrcode.viewfinder")
            }.fullScreenCover(isPresented: $showModal) {
                QRCodeReader(
                    onArtworkResult: { selectArtwork(artworkID: $0) },
                    onClose: closeModal
                )
            }
        }
    }
    
    func selectArtwork(artworkID: String?) {
        self.artworkID = artworkID
        self.canNavigateToArtwork = artworkID != nil
        self.showModal = false
    }
    
    func openModal() {
        showModal = true
    }
    
    func closeModal() {
        showModal = false
    }
}

struct QRCodeReaderButton_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeReaderButton()
    }
}
