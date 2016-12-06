//
//  CacheImage.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/6/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit

let imageCache = URLCache()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as! String)
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        
    }
    
}
