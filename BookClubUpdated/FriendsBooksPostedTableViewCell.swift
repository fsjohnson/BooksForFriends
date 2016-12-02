//
//  FriendsBooksPostedTableViewCell.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/25/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import SDWebImage


class FriendsBooksPostedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postView: PostsView!
    
    var bookID: String!
    
        weak var bookPost: BookPosted! {
            didSet {
                print("loaded did set")
                updateViewToReflectBookImage()
                updateViewToReflectUsername()
                postView.commentLabel.text = bookPost.comment
                updateStars()
            }
        }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


extension FriendsBooksPostedTableViewCell {
    
    
    fileprivate func updateViewToReflectBookImage() {
        guard let url = URL(string: bookPost.imageLink) else { print("no image cover");return }
        postView.bookImage.sd_setImage(with: url, placeholderImage: UIImage(named: "BFFLogo"), options: SDWebImageOptions.refreshCached)
    }
    
    
    fileprivate func updateViewToReflectUsername() {
        UserFirebaseMethods.retrieveSpecificUser(with: bookPost.userUniqueKey, completion: { (user) in
            guard let user = user else { return }
            self.postView.usernameLabel.text = user.username
        })
    }
    
    
    fileprivate func updateStars() {
        
        if postView.starView.subviews.isEmpty {
            postView.star = StarReview(frame: CGRect(x: 0, y: 0, width: postView.starView.bounds.width, height: postView.starView.bounds.height))
            postView.star.starCount = 5
            postView.star.allowEdit = false
            postView.starView.addSubview(postView.star)
            
            
            guard let rating = Float(bookPost.rating) else {return}
            postView.star.value = rating
            postView.star.allowAccruteStars = false
            postView.star.starFillColor = UIColor.red
            postView.star.starBackgroundColor = UIColor.black
            postView.star.starMarginScale = 0.3
        }
    }
    
}

