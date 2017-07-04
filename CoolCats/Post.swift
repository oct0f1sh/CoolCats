//
//  Post.swift
//  CoolCats
//
//  Created by Duncan MacDonald on 7/4/17.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Post {
    var id: String
    var imageURL: String
    var isSaved: Bool
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.imageURL = json["link"].stringValue
        self.isSaved = false
    }
}
