//
//  UserBook.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserBook {
    
    let title: String
    let author: String?
    let finalBookCoverLink: String?
    let synopsis: String?
    let comments: String = "No comment posted"
    let bookUniqueKey: String?
    
    
    init(title: String, author: String, synopsis: String, bookUniqueKey: String?, finalBookCoverLink: String?) {
        self.title = title
        self.author = author
        self.synopsis = synopsis
        self.bookUniqueKey = bookUniqueKey
        self.finalBookCoverLink = finalBookCoverLink
        
    }
}
