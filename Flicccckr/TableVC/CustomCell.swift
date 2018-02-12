//
//  CustomCell.swift
//  Flicccckr
//
//  Created by Егор on 23.11.2017.
//  Copyright © 2017 Егор. All rights reserved.
//

import UIKit
import SDWebImage

class CustomCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func configureSelf (model: Post) {
        titleLabel.text = model.title
        if let url = URL(string: model.photoURL) {
            photoImageView.sd_setImage(with: url)
        }
    }
}
