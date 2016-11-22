//
//  OpenBookSourceAPI.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/21/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit

class OpenBookSourceAPI {
    
    //replace lord+of+the+rings with search text field from AddBookVC
    //"https://openlibrary.org/search.json?title=lilac+girls&author=kelly"
    
    
    class func searchTitles(with searchTitle: String, completion: @escaping ([[String: Any]]) -> Void) {
        
        BookDataStore.shared.generateProperSearch(with: searchTitle) { (title) in
            let searchTitleURL = URL(string: "https://www.googleapis.com/books/v1/volumes?q=intitle:me+before+you+inauthor:moyes&key=\(Constants.apiKey)")
            
            let session: URLSession = URLSession.shared
            guard let unwrappedURL = searchTitleURL else { return }
            
            print(unwrappedURL)
            
            
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
                } else {
                    print(httpResponse.statusCode)
                }
            }
            
            task.resume()
        }
        
        
        
    }
    
    
    class func downloadBookImage(with urlString: String, with completion: @escaping (UIImage) -> Void) {
        
            print("INSIDE DOWNLOAD\n\n\n")
            let searchCoverURL = URL(string: urlString)
            
            guard let unwrappedCoverURL = searchCoverURL else {return}
            print(unwrappedCoverURL)
            
            let session = URLSession.shared
            let request = URLRequest(url: unwrappedCoverURL)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                guard let unwrappedData = data else {return}
                guard let image = UIImage(data: unwrappedData) else {return}
                completion(image)
            }
            
            task.resume()
        }
    
}
