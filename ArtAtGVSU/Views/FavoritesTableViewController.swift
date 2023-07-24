//
//  FavoritesTableViewController.swift
//  ArtAtGVSU
//
//  Created by Kirthi Samson on 4/22/16.
//  Copyright © 2016 Kirthi Samson. All rights reserved.
//

import UIKit
import SDWebImage

class FavoritesTableViewController: UITableViewController {
    let VIEW_NAME = "Favorites"
    var favorites: [Favorite] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = VIEW_NAME
        self.view.backgroundColor = UIColor(named: "Background")

        let nib = UINib(nibName: "customCellWithBlur", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cCellBlur")
    }

    override func viewDidAppear(_ animated: Bool) {
        favorites.removeAll()

        var newFavorites = FavoritesStore.favorites()
        newFavorites.sort(by: { (lhs, rhs) in lhs.artworkID > rhs.artworkID })
        favorites.append(contentsOf: newFavorites)

        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomCellBlurTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cCellBlur", for: indexPath) as! CustomCellBlurTableViewCell
        let favorite = favorites[(indexPath as NSIndexPath).row]
        cell.custom_label.text = favorite.artworkName
        let imageURL = URL(string: favorite.imageURL)
        if let imageURL = imageURL {
            cell.custom_image.sd_setImage(with: imageURL)
        }
        cell.custom_secondary_label.text =  ""
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "favoritesToDetail", sender: nil)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "favoritesToDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! ArtworkDetailController
                controller.artworkID = favorites[(indexPath as NSIndexPath).row].artworkID
            }
        }
    }
}
