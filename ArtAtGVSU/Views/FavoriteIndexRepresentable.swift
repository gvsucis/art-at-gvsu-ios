//
//  FavoriteIndexRepresentable.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 5/22/21.
//  Copyright © 2021 Applied Computing Institute. All rights reserved.
//

import Foundation
import SwiftUI

struct FavoriteIndexRepresentable: UIViewControllerRepresentable {
    var id: UUID?

    func makeUIViewController(context: Context) -> FavoritesTableViewController {
        return UIStoryboard.mainStoryboardInstance(withIdentifier: "FavoritesTableViewController")
    }

    func updateUIViewController(_ uiViewController: FavoritesTableViewController, context: Context) {
        uiViewController.navigationController?.popToRootViewController(animated: true)
    }
}
