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

    var body: some View {
        ZStack {
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
        if let artworkID = artworkID {
            self.artworkID = artworkID

            ArtworkDetailController.present(artworkID: artworkID, modal: true)

            self.showModal = false
        }
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
