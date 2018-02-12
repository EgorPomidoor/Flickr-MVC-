//
//  CustomCollectionViewCell.swift
//  Flicccckr
//
//  Created by Егор on 30.11.2017.
//  Copyright © 2017 Егор. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    func configureSelf(model: Post) {
       
        photoImageView.layer.cornerRadius = 20
        photoImageView.layer.masksToBounds = true
        if let url = URL(string: model.photoURL) {
            photoImageView.sd_setImage(with: url)
        }
    }
}
