//
//  Books.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 10/20/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//import SDWebImage

class SearchedBook {
    
    var title: String
    var author: String?
    var authorArray: [String]?
    var bookCover: UIImage?
    var bookCoverLink: String?
    var bookCoverLinkDict: [String:String]?
    var finalBookCoverLink: String?
    
    
    let volume: [String: Any]
    var synopsis: String? = "Synopsis not available"
    
    
    init(dict: [String: Any]) {
        self.volume = dict["volumeInfo"] as! [String: Any]
        self.title = volume["title"] as! String
        self.authorArray = volume["authors"] as? [String]
        self.author = authorArray?[0]
        self.bookCoverLinkDict = volume["imageLinks"] as? [String:String]
        self.bookCoverLink = bookCoverLinkDict?["thumbnail"]
        self.finalBookCoverLink = bookCoverLink?.replacingOccurrences(of: "http", with: "https")
        self.synopsis = volume["description"] as? String
    }
    
    init(volume: [String: Any], title: String, authorArray: [String]?, author: String, bookCoverLinkDict: [String: String]?, bookCoverLink: String?, finalBookCoverLink: String?, synopsis: String?) {
        
        self.volume = volume
        self.title = title
        self.authorArray = authorArray
        self.author = author
        self.bookCoverLinkDict = bookCoverLinkDict
        self.bookCoverLink = bookCoverLink
        self.finalBookCoverLink = finalBookCoverLink
    }
}

extension SearchedBook: Hashable {
    
    var hashValue: Int {
        
        let authorHash = author?.hashValue ?? 0
        
        return title.hashValue ^ authorHash
        
    }
    
    static func ==(lhs: SearchedBook, rhs: SearchedBook) -> Bool {

        let leftAuthorName = lhs.author ?? "No Name"
        let rightAuthorName = rhs.author ?? "No Name"
        
        return (leftAuthorName + lhs.title) == (rightAuthorName + rhs.title)
    }
    
}



