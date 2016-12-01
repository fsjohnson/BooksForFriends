//
//  UserPostCollectionViewCell.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/29/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import SDWebImage

class UserPostCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    weak var bookPost: BookPosted! {
        didSet {
            print("i got set")
            //setImage()
            //self.setNeedsLayout()
        }
    }
    
    
    var book: BookPosted!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
        
    }
    
    private func commonInit() {
        
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.random
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        self.contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    
    
        
        
    }
    
    
    func configureCell(book: BookPosted){
        
        guard let url = URL(string: book.imageLink) else { print("no image");return }
        //print(url)
        //print(bookPost.imageLink)
        
//        
//        let session = URLSession.shared
//        
//        let dataTask = session.dataTask(with: url) { (data, response, error) in
//            guard let dataresponse = data else { return }
//            
//            let image = UIImage(data: dataresponse)
//            OperationQueue.main.addOperation {
//                self.imageView.image = image
//            }
//            
//        }
//        dataTask.resume()
        
        self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "BFFLogo"), options: SDWebImageOptions.refreshCached)

    
    }
    
    func setImage() {
        
        imageView = UIImageView()
        
        let url = URL(string: "https://s2.dmcdn.net/Ub1O8/1280x720-mCQ.jpg")
        print(url)
        print(bookPost.imageLink)
        
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            guard let dataresponse = data else { return }
            
            let image = UIImage(data: dataresponse)
            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
            
        }
        dataTask.resume()
        
        
//        self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "BFFLogo"), options: SDWebImageOptions.refreshCached)
        
        
        
        
    }
    
    
    
}


extension UIColor{
    class var random :UIColor{
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
