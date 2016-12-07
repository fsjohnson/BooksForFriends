//
//  BookDataStore.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/21/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit

class BookDataStore {
    
    static let shared = BookDataStore()
    private init() {}
    
    var isbn: String?
    var bookArray = [SearchedBook]()
    var imageArray = [UIImage]()
    var searchTitle = String()
    var searchAuthor = String()
    
    func generateProperSearch(with searchQuery: String, authorQuery: String, completion:(String, String) -> Void) {
        
        self.searchTitle = searchQuery.replacingOccurrences(of: " ", with: "+")
        let authorArray = authorQuery.components(separatedBy: " ")
        self.searchAuthor = String(describing: authorArray.last!)
        print(searchTitle)
        print(searchAuthor)
        completion(searchTitle, searchAuthor)
    }
    
    
    func getBookResults(with searchQuery: String, authorQuery: String, completion: @escaping (Bool) -> Void) {
        
        BookDataStore.shared.bookArray.removeAll()
        GoogleBooksAPI.APICall(with: searchQuery, authorName: authorQuery) { (searchResults) in
            for searchResult in searchResults {
                let book = SearchedBook(dict: searchResult)
                self.bookArray.append(book)
            }
            
            if self.bookArray.count > 0 {
                completion(true)
            }
        }
    }
    
}
