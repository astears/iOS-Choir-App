//
//  Message.swift
//  Crescendo_iOS
//
//  Created by Andrew Stears on 3/11/18.
//  Copyright © 2018 Andrew Stears. All rights reserved.
//

import UIKit

class Message: NSObject {
    var text : String?
    var user : String?
    var postID : String?
    var timestamp: String?
    
    init(_ text : String, _ user : String, _ postID : String, _ timestamp : String) {
        self.text = text
        self.user = user
        self.postID = postID
        self.timestamp = timestamp
    }
}
