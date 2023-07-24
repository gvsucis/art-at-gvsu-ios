//
//  CustomTableViewCell.swift
//  ArtAtGVSU
//
//  Created by Kirthi Samson on 5/1/16.
//  Copyright © 2016 Kirthi Samson. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet weak var c_image: UIImageView!
    @IBOutlet weak var c_label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //self.c_image!.frame = CGRect(x: self.c_image!.frame.origin.x, y: self.c_image.frame.origin.y, width: 10,height: 40)
        //self.c_image!.frame = CGRect(x: 0,y: 0,width: 200,height: 200)
    }

}
