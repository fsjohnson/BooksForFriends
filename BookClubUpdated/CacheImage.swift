//
//  CacheImage.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/6/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(urlString: String) {
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as! String)
            }
            
            guard let data = data else { return }
            
            OperationQueue.main.addOperation {
                if let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }.resume()
        
    }
    
}
