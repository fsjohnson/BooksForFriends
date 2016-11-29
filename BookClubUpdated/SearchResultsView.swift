//
//  SearchResultsView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/29/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class SearchResultsView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var authorLabel: UILabel!
    
    weak var searchedBook: SearchedBook! {
        didSet {
//            updateViewToReflectBookImage()
            titleLabel.text = searchedBook.title
            authorLabel.text = searchedBook.author
            OperationQueue.main.addOperation {
                self.bookImage.image = self.searchedBook.bookCover
            }
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SearchResultsView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.constrainEdges(view:self)
        backgroundColor = UIColor.clear
    }
}

extension SearchResultsView {
    
    fileprivate func updateViewToReflectBookImage() {
        
        
        
        
//        if bookImage.image == nil {
//            guard let link = searchedBook.finalBookCoverLink else {return}
//            
//            if link != "" {
//                GoogleBooksAPI.downloadBookImage(with: link, with: { (image) in
//                    OperationQueue.main.addOperation {
//                        self.bookImage.image = image
//                    }
//                })
//
//            } else {
//                
//                self.bookImage.image = UIImage(named: "BFFLogo")
//                
//            }
        
//        }
    }
}

// MARK: - UIView Extension
extension UIView {
    
    func constrainEdges(view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
