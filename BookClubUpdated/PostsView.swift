//
//  PostsView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/28/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

protocol BookPostDelegate: class {
    func canDisplayImage(sender: PostsView) -> Bool
}

class PostsView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flagButtonOutlet: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var starView: UIView!
    var star: StarReview!
    
    weak var delegate: BookPostDelegate!
    
    
    weak var bookPost: BookPosted! {
        didSet {
            updateViewToReflectBookImage()
            commentLabel.text = bookPost.comment
            titleLabel.text = bookPost.title
            updateViewToReflectUsername()
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
        self.contentView.layer.borderColor = UIColor.themeWhite.cgColor
        self.contentView.layer.borderWidth = 4.0
        
        // Username Config
        usernameLabel.font = UIFont.themeSmallBold
        usernameLabel.textColor = UIColor.themeDarkGrey
        
        
        // Book Title Config
        titleLabel.font = UIFont.themeSmallBold
        titleLabel.textColor = UIColor.themeOrange
        
        // Comment Label Config
        commentLabel.font = UIFont.themeSmallLight
        commentLabel.textColor = UIColor.themeDarkGrey


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

//Mark: Cell content

extension PostsView {
    
    fileprivate func updateViewToReflectBookImage() {
        
        guard bookPost.bookCover == nil else { bookImage.image = bookPost.bookCover; return }
        
        if bookPost.imageLink == "" {
            bookPost.bookCover = UIImage(named: "BFFLogo")
            bookImage.image = bookPost.bookCover
        } else {
            OperationQueue.main.addOperation {
                if self.delegate.canDisplayImage(sender: self) {
                    self.bookImage.loadImageUsingCacheWithURLString(urlString: self.bookPost.imageLink)
                }
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
        
        starView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.frame.width.multiplied(by: 0.1)).isActive = true
        starView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        star = StarReview(frame: CGRect(x: 0.2, y: 0, width: starView.bounds.width, height: starView.bounds.height))
        star.starCount = 5
        star.allowEdit = false
        starView.addSubview(star)
        star.allowAccruteStars = false
        star.starFillColor = UIColor.themeLightBlue
        star.starBackgroundColor = UIColor.themeDarkBlue
        star.starMarginScale = 0.1
        
        if starView.subviews.isEmpty {
            guard let rating = Float(bookPost.rating) else {return}
            star.value = rating
        }
    }

}

