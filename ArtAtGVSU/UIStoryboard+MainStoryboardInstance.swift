//
//  UIStoryboard+WithMainStoryboard.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/22/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func mainStoryboardInstance<T: UIViewController>(withIdentifier identifier: String) -> T {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
}
