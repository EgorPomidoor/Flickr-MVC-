//
//  Post.swift
//  Flicccckr
//
//  Created by Егор on 23.11.2017.
//  Copyright © 2017 Егор. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var id: String
    var photoURL: String
    var title: String
    
    var downloadedSize: CGSize?
    
    
    init (id: String, photoURL: String, title: String) {
        self.title = title
        self.id = id
        self.photoURL = photoURL
    }
}
