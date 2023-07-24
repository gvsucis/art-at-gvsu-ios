//
//  Appearance.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/30/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation

enum Appearance: String {
    case dark
    case light
    case systemDefault

    static let DARK = "dark"
    static let LIGHT = "light"
    static let SYSTEM_DEFAULT = "systemDefault"

    static func from(_ string: String) -> Appearance {
        if string == DARK {
            return Appearance.dark
        } else if string == LIGHT {
            return Appearance.light
        } else {
            return Appearance.systemDefault
        }
    }
}
