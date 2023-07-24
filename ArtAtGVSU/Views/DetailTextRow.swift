//
//  ArtworkDetailRow.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 4/26/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct DetailTextRow: View {
    let title: String
    let description: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(title))
                    .font(.title3)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                Text(description)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color(UIColor.label))
            }
            Spacer()
        }
    }
}

struct ArtworkDetailTextRow_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background
            DetailTextRow(title: "artworkDetail_HistoricalContext", description: "Bar")
        }
        .previewLayout(.fixed(width: 400, height: 100))

        ZStack {
            Color.background
            DetailTextRow(title: "Foo", description: longText)
        }
        .previewLayout(.fixed(width: 400, height: 250))
        .previewDisplayName("Long Text")
    }

    static let longText = "Judith Brown employed scrap metal in much of her work, ranging from small religious ceremonial objects such as a Hanukkah lamp in the collection of The Jewish Museum, to monumental sculptures and public art projects like the installation commissioned for the Federal Courthouse building in Trenton, New Jersey."
}
