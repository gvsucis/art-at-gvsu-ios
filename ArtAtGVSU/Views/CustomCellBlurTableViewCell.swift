//
//  CustomCellBlurTableViewCell.swift
//  ArtAtGVSU
//
//  Created by Kirthi Samson on 5/1/16.
//  Copyright © 2016 Kirthi Samson. All rights reserved.
//

import UIKit

class CustomCellBlurTableViewCell: UITableViewCell {

    @IBOutlet weak var custom_image: UIImageView!
    @IBOutlet weak var custom_label: UILabel!
    @IBOutlet weak var custom_secondary_label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
