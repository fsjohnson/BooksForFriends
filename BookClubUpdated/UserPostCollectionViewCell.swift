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
           
        if let url = URL(string: book.imageLink) {
            self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "BFFLogo"), options: SDWebImageOptions.refreshCached)
        } else {
            
            self.imageView.image = UIImage(named: "BFFLogo")
        }
    }
    
}

