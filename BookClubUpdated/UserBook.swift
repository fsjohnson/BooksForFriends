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
//    var bookCover: UIImage?
//    let finalBookCoverLink: String?
    let synopsis: String?
//    let comments: String?
//    let rating: String?
//    let bookUniqueKey: String?
    
    
    init(title: String, author: String, synopsis: String) {
        self.title = title
        self.author = author
        self.synopsis = synopsis
        
    }
}
