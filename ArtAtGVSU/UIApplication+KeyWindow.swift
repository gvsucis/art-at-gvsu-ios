//
//  UIApplication+KeyWindow.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 4/27/26.
//  Copyright © 2026 Applied Computing Institute. All rights reserved.
//

import UIKit

extension UIApplication {
    var keyWindowRootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController
    }
}
