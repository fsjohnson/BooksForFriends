//
//  FollowersFollowing.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/24/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class FollowersFollowing: UIView {
    
    @IBOutlet weak var booksPostedLabel: UILabel!
    
    @IBOutlet var wholeView: UIView!
    
    @IBOutlet weak var booksPosted: UILabel!

    @IBOutlet weak var numFollowers: UILabel!
    
    @IBOutlet weak var numFollowing: UILabel!
    
    @IBOutlet weak var contentView: UIStackView!
    
    @IBOutlet weak var followersButtonOutlet: UIButton!
    
    @IBOutlet weak var followingButtonOutlet: UIButton!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        populatePostsLabel()
        populateFollowersLabel()
        populateFollowingLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        populatePostsLabel()
        populateFollowersLabel()
        populateFollowingLabel()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FollowersFollowing", owner: self, options: nil)
        wholeView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wholeView)
        wholeView.constrainEdges(to: self)
        backgroundColor = UIColor.clear
        
        booksPostedLabel.layer.borderWidth = 4.0
        booksPostedLabel.layer.borderColor = UIColor.themeLightBlue.cgColor
        
        
        
        followersButtonOutlet.titleLabel?.textAlignment = NSTextAlignment.center
        followersButtonOutlet.titleLabel?.numberOfLines = 0
        followersButtonOutlet.layer.borderWidth = 4.0
        followersButtonOutlet.layer.borderColor = UIColor.themeLightBlue.cgColor

        followingButtonOutlet.titleLabel?.textAlignment = NSTextAlignment.center
        followingButtonOutlet.layer.borderWidth = 4.0
        followingButtonOutlet.layer.borderColor = UIColor.themeLightBlue.cgColor
        followingButtonOutlet.titleLabel?.numberOfLines = 0
    }
    
}


// MARK: - Configure View
extension FollowersFollowing {
    
    func constrainToEdges(to view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func populateFollowersLabel() {

        let attrs1 = [NSFontAttributeName : UIFont.themeSmallBold, NSForegroundColorAttributeName : UIColor.themeLightBlue]
        
        let attrs2 = [NSFontAttributeName : UIFont.themeTinyBold, NSForegroundColorAttributeName : UIColor.themeLightBlue]
        
        UserFirebaseMethods.retriveFollowers { (users) in
            
            let text = String(users.count)
            if users.count == 0 {
                
                let attributedString1 = NSMutableAttributedString(string:"0\n", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"Followers", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                
                self.followersButtonOutlet.titleLabel?.attributedText = attributedString1
                self.followersButtonOutlet.setTitle(attributedString1.string, for: .normal)
                
            } else {
                let attributedString1 = NSMutableAttributedString(string:"\(text)\n", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"Followers", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                
                self.followersButtonOutlet.titleLabel?.attributedText = attributedString1
            }
        }
    }
    
    func populateFollowingLabel() {
        
        let attrs1 = [NSFontAttributeName : UIFont.themeSmallBold, NSForegroundColorAttributeName : UIColor.themeLightBlue]
        
        let attrs2 = [NSFontAttributeName : UIFont.themeTinyBold, NSForegroundColorAttributeName : UIColor.themeLightBlue]
        
        UserFirebaseMethods.retriveFollowingUsers { (users) in
            let text = String(users.count)
            if users.count == 0 {
                let attributedString1 = NSMutableAttributedString(string:"0\n", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"Following", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                self.followingButtonOutlet.setTitle(attributedString1.string, for: .normal)
                
            } else {
                let attributedString1 = NSMutableAttributedString(string:"\(text)\n", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"Following", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                self.followingButtonOutlet.titleLabel?.attributedText = attributedString1
            }
        }
    }
    
    func populatePostsLabel() {
        let attrs1 = [NSFontAttributeName : UIFont.themeSmallBold, NSForegroundColorAttributeName : UIColor.themeLightBlue]
        
        let attrs2 = [NSFontAttributeName : UIFont.themeTinyBold, NSForegroundColorAttributeName : UIColor.themeLightBlue]
        
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        PostsFirebaseMethods.downloadUsersBookPostsArray(with: currentUserID) { (booksPosted) in
            let text = String(booksPosted.count)
            if booksPosted.count == 0 {
                let attributedString1 = NSMutableAttributedString(string:"0\n", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"Books Posted", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                self.booksPostedLabel.attributedText = attributedString1
                
            } else {
                let attributedString1 = NSMutableAttributedString(string:"\(text)\n", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"Books Posted", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                self.booksPostedLabel.attributedText = attributedString1
                                
            }
        }
    }
    
}

