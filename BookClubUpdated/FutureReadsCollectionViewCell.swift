//
//  FutureReadsCollectionViewCell.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/26/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class FutureReadsCollectionViewCell: UICollectionViewCell {

    let bookCoverImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    private func commonInit() {
        
        
        bookCoverImageView.contentMode = .scaleAspectFill
        bookCoverImageView.clipsToBounds = true
        
        self.contentView.addSubview(bookCoverImageView)
        
        bookCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        bookCoverImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        bookCoverImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        bookCoverImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        bookCoverImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        
    }
}
