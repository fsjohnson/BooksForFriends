//
//  PostsView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/28/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import SDWebImage

class PostsView: UIView {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var starView: UIView!
    var star: StarReview!
    
    weak var bookPost: BookPosted! {
        didSet {
            updateViewToReflectBookImage()
            updateViewToReflectUsername()
            commentLabel.text = bookPost.comment
            updateStars()
            
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
        Bundle.main.loadNibNamed("PostsView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.constrainEdges(to: self)
        backgroundColor = UIColor.clear

    }
}

extension PostsView {

    
    fileprivate func updateViewToReflectBookImage() {
        if bookImage.image == nil {
            if bookPost.imageLink != "" {
                
                GoogleBooksAPI.downloadBookImage(with: bookPost.imageLink, with: { (image) in
                    OperationQueue.main.addOperation {
                        self.bookImage.image = image
                    }
                })
                
            } else {
                self.bookImage.image = UIImage(named: "BFFLogo")
            }
            
        }
    }
    
    
    fileprivate func updateViewToReflectUsername() {
        UserFirebaseMethods.retrieveSpecificUser(with: bookPost.userUniqueKey, completion: { (user) in
            guard let user = user else { return }
            self.usernameLabel.text = user.username
        })
    }
    
    
    fileprivate func updateStars() {
        
        if starView.subviews.isEmpty {
            self.star = StarReview(frame: CGRect(x: 0, y: 0, width: starView.bounds.width, height: starView.bounds.height))
            self.star.starCount = 5
            self.star.allowEdit = false
            starView.addSubview(self.star)
            
            
            guard let rating = Float(bookPost.rating) else {return}
            self.star.value = rating
            self.star.allowAccruteStars = false
            self.star.starFillColor = UIColor.red
            self.star.starBackgroundColor = UIColor.black
            self.star.starMarginScale = 0.3
        }
        
        
    }
    
}

// MARK: - UIView Extension
extension UIView {
    
    func constrainEdges(to view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

