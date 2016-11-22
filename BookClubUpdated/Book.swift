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
    let author: String
    let authorArray: [String]
    let isbnArray: [String]
    var recommend: Bool?
    let isbn: String
    var bookCover: UIImage?
    
    
    init(dict: [String: Any]) {
        self.title = dict["title"] as! String
        self.authorArray = dict["author_name"] as! [String]
        self.author = authorArray[0]
        self.isbnArray = (dict["isbn"] as? [String])!
        self.isbn = (isbnArray[0])
        
        OpenBookSourceAPI.downloadBookImage(with: isbn) { (image) in
            self.bookCover = image
        }
        
    }
    
    enum BookFeelings {
        case hated, indifferent, liked, loved
    }
    
}



