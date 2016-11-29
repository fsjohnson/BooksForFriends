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
                
                urlToPass = "https://www.googleapis.com/books/v1/volumes?q=intitle:\(title)&langRestrict:en&printType=books&key=\(Constants.apiKey)"
            } else {
                
                urlToPass = "https://www.googleapis.com/books/v1/volumes?q=intitle:\(title)+inauthor:\(author)&langRestrict:en&printType=books&key=\(Constants.apiKey)"
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
                    print(error?.localizedDescription)
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

    class func downloadBookImage(with urlString: String, with completion: @escaping (UIImage) -> Void) {
        
        let searchCoverURL = URL(string: urlString)
        
        let session = URLSession.shared
        
        let request = URLRequest(url: searchCoverURL!)
        
        session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let rawData = data, let image = UIImage(data: rawData) else { return }
            
            completion(image)
            
        }).resume()

//        guard let unwrappedCoverURL = searchCoverURL else {return}
//        
//        do {
//            let imageData = try Data(contentsOf: unwrappedCoverURL)
//            guard let image = UIImage(data: imageData) else {return}
//            completion(image)
//
//        } catch {}
    }
}





