//
//  UserColorTheme.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/30/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import SwiftUI

struct UserColorTheme: ViewModifier {
    @AppStorage(APPEARANCE_KEY) var appearanceSetting: String = Appearance.DARK

    var colorScheme: ColorScheme? {
        switch Appearance.from(appearanceSetting) {
        case Appearance.dark:
            return ColorScheme.dark
        case Appearance.light:
            return ColorScheme.light
        default:
            return nil
        }
    }

    func body(content: Content) -> some View {
        content.preferredColorScheme(colorScheme)
    }
}

let APPEARANCE_KEY = "appearance"

extension View {
    func userColorTheme() -> some View {
        self.modifier(UserColorTheme())
    }
}
