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
        setImage()

    }
    
    func setImage() {
        if imageLink != "" {
            GoogleBooksAPI.downloadBookImage(with: imageLink) { (image) in
                print("IMAGE LINK: \(self.imageLink)")
                self.bookCover = image
            }
        } else {
            self.bookCover = UIImage(named: "BFFLogo")
        }
        
    }
    
    func convertTimestampIntoDate(with timestamp: String, completion: (Date) -> Void) {
        let dateTimeStamp = NSDate(timeIntervalSince1970:Double(timestamp)!/1000)  //UTC time
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Edit
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        
        let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
        print(strDateSelect) //Local time
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = NSTimeZone.local
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        
        guard let date3 = dateFormatter.date(from: strDateSelect) else { print("coulnd't convert timestamp to date"); return }
        
        completion(date3)
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

