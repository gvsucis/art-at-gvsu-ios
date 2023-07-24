//
//  Translate.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 8/1/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//
//  https://stackoverflow.com/questions/60841915/how-to-change-localizedstringkey-to-string-in-swiftui
//
import Foundation
import SwiftUI

func translate(_ localizedKey: String) -> String {
    return NSLocalizedString(localizedKey, comment: "default")
}
