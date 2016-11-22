//
//  Books.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 10/20/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit

class Book {
    
    let title: String
    let author: String?
    let authorArray: [String]?
    var recommend: Bool?
    var bookCover: UIImage?
    let bookCoverLink: String?
    let bookCoverLinkDict: [String:String]?
    let linkToPass: String?

    let volume: [String: Any]
        let description: String?
//        let isbn: String
//        let isbnArray: [[String:String]]
    
    
    init(dict: [String: Any]) {
        self.volume = dict["volumeInfo"] as! [String: Any]
        self.title = volume["title"] as! String
        self.authorArray = volume["authors"] as? [String]
        self.author = authorArray?[0]
        self.bookCoverLinkDict = volume["imageLinks"] as? [String:String]
        self.bookCoverLink = bookCoverLinkDict?["thumbnail"]
        self.linkToPass = bookCoverLink?.replacingOccurrences(of: "http", with: "https")
        self.description = volume["description"] as? String
        
        guard let link = linkToPass else {return}
        
        OpenBookSourceAPI.downloadBookImage(with: link) { (image) in
               self.bookCover = image
        }

        
        //        self.isbnArray = (volume["industryIdentifiers"] as? [[String:String]])!
        //        self.isbn = isbnArray[0]["identifier"]!
        
        
    }
    
    enum BookFeelings {
        case hated, indifferent, liked, loved
    }
    
}



