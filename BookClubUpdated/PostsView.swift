//
//  PostsView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/28/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class PostsView: UIView {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var starView: UIView!
    
    weak var bookPost: BookPosted! {
        didSet {
            updateViewToReflectBookImage()
            updateViewToReflectUsername()
            commentLabel.text = bookPost.comment
            print("COMMENT: \(bookPost.comment)")
            print("RATING: \(bookPost.rating)")
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
        print(usernameLabel.text)
        UserFirebaseMethods.retrieveSpecificUser(with: bookPost.userUniqueKey, completion: { (user) in
            print("USER: \(user)")
            guard let user = user else { return }
            self.usernameLabel.text = user.username
        })
    }
    
    
    fileprivate func updateStars() {
        
        
        let star2 = StarReview(frame: CGRect(x: 0, y: 0, width: starView.bounds.width, height: starView.bounds.height))
        star2.starCount = 5
        star2.allowEdit = false

        guard let rating = Float(bookPost.rating) else {return}
        star2.value = rating
        star2.allowAccruteStars = false
        star2.starFillColor = UIColor.red
        star2.starBackgroundColor = UIColor.black
        star2.starMarginScale = 0.3
        starView.addSubview(star2)
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

