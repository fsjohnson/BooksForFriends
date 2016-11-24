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
    
    
    static func retrieveBook(with bookUniqueID: String, completion: @escaping (UserBook?)-> Void) {
        print("PROGRESS: Retreiving Book Data")
        
        let bookRef = FIRDatabase.database().reference().child("books").child(bookUniqueID)
        
        
        bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let bookInfoRaw = snapshot.value as? [String:Any]
            
            guard
                let bookInfo = bookInfoRaw,
                let title = bookInfo["title"] as?  String,
                let author = bookInfo["author"] as? String,
//                let finalBookCoverLink = bookInfo["finalBookCoverLink"] as? String,
//                let bookUniqueKey = bookInfo["bookUniqueKey"] as? String,
                let synopsis = bookInfo["synopsis"] as? String
                else { print("\n\n\n\n\n\(bookInfoRaw)\n\n\n\n"); return }
            
            let book = UserBook(title: title, author: author, synopsis: synopsis)
            completion(book)

        })
    }

    
    
}
