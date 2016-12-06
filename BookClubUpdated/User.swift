//
//  UsersInformation.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 10/20/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    
    var name: String
    var uniqueKey: String
    var email: String
    var username: String
    var profileImageURL: UIImage?

    
    
    init(name: String, email: String, uniqueKey: String, username: String) {
        self.name = name
        self.email = email
        self.uniqueKey = uniqueKey
        self.username = username
    }
}

