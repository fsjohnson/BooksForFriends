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
    var searchCount = Int()
    
    
    func generateProperSearch(with searchQuery: String, completion:(String) -> Void) {
        
        self.searchTitle = searchQuery.replacingOccurrences(of: " ", with: "+")
        completion(searchTitle)
    }
    
    
    func getBookResults(with searchQuery: String, completion: @escaping ([Book]) -> Void) {
        
        OpenBookSourceAPI.searchTitles(with: searchQuery) { (searchResults) in
            for searchResult in searchResults {
                let book = Book(dict: searchResult)
                print(book.author)
                print(book.title)
                self.bookArray.append(book)
                self.searchCount = self.bookArray.count
            }
            
            completion(self.bookArray)
        }
        
        print(bookArray)
        
    }
    
}
