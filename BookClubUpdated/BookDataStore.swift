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
    var bookArray = [Book]()
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
    
    
    func getBookResults(with searchQuery: String, authorQuery: String, completion: @escaping ([Book]) -> Void) {
        bookArray.removeAll()
        OpenBookSourceAPI.searchTitles(with: searchQuery, authorName: authorQuery) { (searchResults) in
            for searchResult in searchResults {
                let book = Book(dict: searchResult)
                self.bookArray.append(book)
            }
            
            self.bookArray.sort(by: { (first, second) -> Bool in
                return first.title < second.title
            })
            
            completion(self.bookArray)
        }
    }
    
}
