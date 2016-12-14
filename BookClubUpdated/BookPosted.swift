//
//  BooksPosted.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/26/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit

class BookPosted {
    
    let bookUniqueID: String
    let rating: String
    let comment: String
    let imageLink: String
    let timestamp: Double
    let dateSent: Date
    var bookCover: UIImage?
    var username: String?
    var userUniqueKey: String
    var isFlagged: Bool?
    let reviewID: String
    let title: String
    
    init(bookUniqueID: String, rating: String, comment: String, imageLink: String, timestamp: Double, userUniqueKey: String, reviewID: String, title: String) {
        self.bookUniqueID = bookUniqueID
        self.rating = rating
        self.comment = comment
        self.imageLink = imageLink
        
        self.timestamp = timestamp
        self.dateSent = Date(timeIntervalSince1970: timestamp)
        self.userUniqueKey = userUniqueKey
        self.reviewID = reviewID
        self.title = title
    }
}


extension BookPosted: Hashable {
    
    var hashValue: Int {
        
        return bookUniqueID.hashValue
        
    }
    
    static func ==(lhs: BookPosted, rhs: BookPosted) -> Bool {
        
        return (lhs.bookUniqueID) == (rhs.bookUniqueID)
    }
}

