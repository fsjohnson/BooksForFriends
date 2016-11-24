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

class SearchedBook {
    
    let title: String
    let author: String?
    let authorArray: [String]?
    var bookCover: UIImage?
    let bookCoverLink: String?
    let bookCoverLinkDict: [String:String]?
    let finalBookCoverLink: String?
    
    let volume: [String: Any]
    let synopsis: String?
    
    init(dict: [String: Any]) {
        self.volume = dict["volumeInfo"] as! [String: Any]
        self.title = volume["title"] as! String
        self.authorArray = volume["authors"] as? [String]
        self.author = authorArray?[0]
        self.bookCoverLinkDict = volume["imageLinks"] as? [String:String]
        self.bookCoverLink = bookCoverLinkDict?["thumbnail"]
        self.finalBookCoverLink = bookCoverLink?.replacingOccurrences(of: "http", with: "https")
        self.synopsis = volume["description"] as? String
        
        guard let link = finalBookCoverLink else {return}
        
        GoogleBooksAPI.downloadBookImage(with: link) { (image) in
            self.bookCover = image
        }
    }
    
}



