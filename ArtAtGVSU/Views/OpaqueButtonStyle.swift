//
//  OpaqueButtonStyle.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/25/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct OpaqueButtonStyle: ButtonStyle {
    public func makeBody(configuration: OpaqueButtonStyle.Configuration) -> some View {
        configuration.label
            .opacity(1)
    }
}
