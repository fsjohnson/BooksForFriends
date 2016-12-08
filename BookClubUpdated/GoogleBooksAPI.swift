//
//  OpenBookSourceAPI.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/21/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit

class GoogleBooksAPI {
    
    class func searchTitles(with searchTitle: String, authorName: String, completion: (String) -> Void) {
        
        var urlToPass = String()
        
        BookDataStore.shared.generateProperSearch(with: searchTitle, authorQuery: authorName) { (title, author) in
            
            if author == "" {
                urlToPass = "https://www.googleapis.com/books/v1/volumes?q=intitle:\(title)&langRestrict:en&printType=books&orderBy=newest&key=\(Constants.apiKey)"
                //urlToPass = "https://www.googleapis.com/books/v1/volumes?q=intitle:\(title)&langRestrict:en&printType=books&key=\(Constants.apiKey)"
                
            } else {
                urlToPass = "https://www.googleapis.com/books/v1/volumes?q=intitle:\(title)+inauthor:\(author)&langRestrict:en&printType=books&orderBy=newest&key=\(Constants.apiKey)"
                //urlToPass = "https://www.googleapis.com/books/v1/volumes?q=intitle:\(title)+inauthor:\(author)&langRestrict:en&printType=books&key=\(Constants.apiKey)"
            }
            completion(urlToPass)
        }
    }
    
    
    class func APICall(with searchTitle: String, authorName: String, completion: @escaping ([[String: Any]]) -> Void) {
        searchTitles(with: searchTitle, authorName: authorName) { (passedURL) in
            let session = URLSession.shared
            let url = URL(string: passedURL)
            guard let unwrappedURL = url else {return}
            
            let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
                if error != nil {
                    guard let error = error?.localizedDescription else { return }
                    print(error)
                }
                
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    if let unwrappedData = data {
                        do {
                            let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [String: Any]
                            
                            
                            guard let bookInfo = responseJSON["items"] as? [[String: Any]] else {return}
                            
                            completion(bookInfo)
                            
                        } catch {}
                    }
                } else { print(httpResponse.statusCode)}
            }
            task.resume()
        }
    }
    
    
    class func apiSearchBarCode(with barCode: String, completion: @escaping ([String: Any]) -> Void) {
        
        let isbnURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:\(barCode)&key=\(Constants.apiKey)"
        let session = URLSession.shared
        let url = URL(string: isbnURL)
        guard let unwrappedURL = url else {return}
        
        let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
            if error != nil {
                guard let error = error?.localizedDescription else { return }
                print(error)
            }
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                if let unwrappedData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [String: Any]
                    
                        guard let bookInfo = responseJSON["items"] as? [String: Any] else {return}
                        
                        completion(bookInfo)
                        
                    } catch {}
                }
            } else { print(httpResponse.statusCode)}
        }
        task.resume()
    }
}





