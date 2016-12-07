//
//  SearchResultsView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/29/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

protocol SearchResultDelegate: class {
    func canDisplayImage(sender: SearchResultsView) -> Bool
}

class SearchResultsView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    weak var delegate: SearchResultDelegate!
    
    weak var searchedBook: SearchedBook! {
        didSet {
            updateViewToReflectBookImage()
            titleLabel.text = searchedBook.title
            authorLabel.text = searchedBook.author
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
        contentView.constrainEdges(to: self)
        backgroundColor = UIColor.clear
        
    }
}

extension SearchResultsView {
    
    fileprivate func updateViewToReflectBookImage() {
        
        guard searchedBook.bookCover == nil else { bookImage.image = searchedBook.bookCover; print("book image doesnt exit");return }
        
        guard let link = searchedBook.finalBookCoverLink else {
            searchedBook.bookCover = UIImage(named: "BFFLogo")
            bookImage.image = searchedBook.bookCover
            return
        }
        
        OperationQueue.main.addOperation {
            if self.delegate.canDisplayImage(sender: self) {
                self.bookImage.loadImageUsingCacheWithURLString(urlString: link)
            }
        }
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
