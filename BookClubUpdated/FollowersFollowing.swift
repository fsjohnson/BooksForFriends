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
    @IBOutlet weak var booksPostedButton: UIButton!
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var numFollowingOutlet: UILabel!
    @IBOutlet weak var numFollowersOutlet: UILabel!
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var followersButtonOutlet: UIButton!
    @IBOutlet weak var followingButtonOutlet: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    
    
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
        
        // Image Config
        
        profilePic.backgroundColor = UIColor.blue
        profilePic.image = UIImage(named: "BFFLogo")
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.contentMode = .scaleAspectFill
        profilePic.clipsToBounds = true
        profilePic.isUserInteractionEnabled = true
        profilePic.layer.cornerRadius = 0.5 * profilePic.bounds.size.height
        
        // Book Post Label Config
        
        booksPostedLabel.textColor = UIColor.themeLightBlue
        booksPostedLabel.font = UIFont.themeTinyBold
        booksPostedLabel.text = "Books Posted"
        
        // Followers Post Label Config
        
        numFollowersOutlet.textColor = UIColor.themeLightBlue
        numFollowersOutlet.font = UIFont.themeTinyBold
        numFollowersOutlet.text = "Followers"
        
        // Following Post Label Config
        
        numFollowingOutlet.textColor = UIColor.themeLightBlue
        numFollowingOutlet.font = UIFont.themeTinyBold
        numFollowingOutlet.text = "Following"
        
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
        
        UserFirebaseMethods.retriveFollowers { (users) in
            
            print("COUNT: \(users.count)")
            
            var text = String()
            if users.count == 0 {
                text = "0"
            } else {
                text = String(users.count)
            }
            
            self.followersButtonOutlet.titleLabel?.text = text
            self.followersButtonOutlet.titleLabel?.textColor = UIColor.themeLightBlue
            self.followersButtonOutlet.titleLabel?.font = UIFont.themeSmallBold
        }
    }
    
    func populateFollowingLabel() {
        
        UserFirebaseMethods.retriveFollowingUsers { (users) in
            var text = String()
            if users.count == 0 {
                text = "0"
            } else {
                text = String(users.count)
            }
            self.followingButtonOutlet.titleLabel?.text = text
            self.followingButtonOutlet.setTitleColor(UIColor.themeLightBlue, for: .normal)
            self.followingButtonOutlet.titleLabel?.font = UIFont.themeSmallBold
        }
    }
    
    func populatePostsLabel() {
        
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        PostsFirebaseMethods.downloadUsersBookPostsArray(with: currentUserID) { (booksPosted) in
            
            print("COUNT: \(booksPosted.count)")
            var text = String()
            if booksPosted.count == 0 {
                text = "0"
            } else {
                text = String(booksPosted.count)
            }
            self.booksPostedButton.setTitle(text, for: .normal)
            self.booksPostedButton.setTitleColor(UIColor.themeLightBlue, for: .normal)
            self.booksPostedButton.titleLabel?.font = UIFont.themeSmallBold
            
        }
    }
    
}

