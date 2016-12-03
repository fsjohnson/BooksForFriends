//
//  PostsView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/28/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import SDWebImage

protocol BookPostDelegate: class {
    func canDisplayImage(sender: PostsView) -> Bool
}

class PostsView: UIView {
    
    
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
        backgroundColor = UIColor.clear
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
        }
        
        GoogleBooksAPI.downloadBookImage(with: bookPost.imageLink, with: { (image) in
            
            DispatchQueue.main.async {
                
                self.bookPost.bookCover = image
                
                if self.delegate.canDisplayImage(sender: self) {
                    
                    self.bookImage.image = self.bookPost.bookCover
                    
                }
            }
        })
    }
    
    
    fileprivate func updateViewToReflectUsername() {
        UserFirebaseMethods.retrieveSpecificUser(with: bookPost.userUniqueKey, completion: { (user) in
            guard let user = user else { return }
            self.usernameLabel.text = user.username
        })
    }
    
    
    fileprivate func updateStars() {
        
        if starView.subviews.isEmpty {
            star = StarReview(frame: CGRect(x: 0, y: 0, width: starView.bounds.width, height: starView.bounds.height))
            star.starCount = 5
            star.allowEdit = false
            starView.addSubview(star)
            
            
            guard let rating = Float(bookPost.rating) else {return}
            star.value = rating
            star.allowAccruteStars = false
            star.starFillColor = UIColor.red
            star.starBackgroundColor = UIColor.black
            star.starMarginScale = 0.3
        }
    }

}

