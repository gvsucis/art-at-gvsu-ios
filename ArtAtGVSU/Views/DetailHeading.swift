//
//  DetailHeading.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/23/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

extension Text {
    func detailHeading() -> Text {
        self
            .font(Font.title)
            .fontWeight(Font.Weight.bold)
            .foregroundColor(Color(UIColor.label))
    }
}

struct DetailHeading_Previews: PreviewProvider {
    static var previews: some View {
        Text("Amaranth")
            .detailHeading()
            .previewLayout(.sizeThatFits)

        Text("Aramant")
            .detailHeading()
            .background(Color.background)
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
    }
}
