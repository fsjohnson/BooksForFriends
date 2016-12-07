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
        populateProfilePic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        populatePostsLabel()
        populateFollowersLabel()
        populateFollowingLabel()
        populateProfilePic()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FollowersFollowing", owner: self, options: nil)
        wholeView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wholeView)
        wholeView.constrainEdges(to: self)
        backgroundColor = UIColor.clear
        
        // Image Config
        
        self.layoutIfNeeded()
        profilePic.isUserInteractionEnabled = true
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        
        
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
        
        // Book Post Button Config
        
        self.booksPostedButton.setTitleColor(UIColor.themeLightBlue, for: .normal)
        self.booksPostedButton.titleLabel?.font = UIFont.themeSmallBold
        
        // Followers Button Config
        
        self.followersButtonOutlet.setTitleColor(UIColor.themeLightBlue, for: .normal)
        self.followersButtonOutlet.titleLabel?.font = UIFont.themeSmallBold
        
        // Following Button Config
        
        self.followingButtonOutlet.setTitleColor(UIColor.themeLightBlue, for: .normal)
        self.followingButtonOutlet.titleLabel?.font = UIFont.themeSmallBold
        
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
        UserFirebaseMethods.checkIfFollowerUsersIsEmpty { (isEmpty) in
            if isEmpty ==  true {
                DispatchQueue.main.async {
                    self.followersButtonOutlet.setTitle("0", for: .normal)
                }
            } else {
                UserFirebaseMethods.retriveFollowers { (users) in
                    DispatchQueue.main.async {
                        self.followersButtonOutlet.setTitle(String(users.count), for: .normal)
                    }
                }
            }
        }
        
    }
    
    func populateFollowingLabel() {
        UserFirebaseMethods.checkIfFollowingUsersIsEmpty { (isEmpty) in
            if isEmpty == true {
                DispatchQueue.main.async {
                    self.followingButtonOutlet.setTitle("0", for: .normal)
                }
                
            } else {
                UserFirebaseMethods.retriveFollowingUsers { (users) in
                    DispatchQueue.main.async {
                        self.followingButtonOutlet.setTitle(String(users.count), for: .normal)
                    }
                }
            }
        }
        
    }
    
    func populatePostsLabel() {
        booksPostedButton.setTitle(nil, for: .normal)
        booksPostedButton.alpha = 0.0
        
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        PostsFirebaseMethods.downloadUsersBookPostsArray(with: currentUserID) { [unowned self] booksPosted in
            
            DispatchQueue.main.async {
                
                let title = booksPosted != nil ? String(booksPosted!.count) : "0"
                self.booksPostedButton.setTitle(title, for: .normal)

                UIView.animate(withDuration: 0.8, animations: {
                    self.booksPostedButton.alpha = 1.0
                })
            }
        }
    }
    
    func populateProfilePic() {
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        UserFirebaseMethods.retrieveSpecificUser(with: currentUserID) { (currentUser) in
            print("LINK: \(currentUser?.profileImageURL)")
            if currentUser?.profileImageURL == "no image" {
                self.profilePic.image = UIImage(named: "BFFLogo")
                self.profilePic.contentMode = .scaleAspectFit
            } else {
                if let profileImageURL = currentUser?.profileImageURL {
                    DispatchQueue.main.async {
                        self.profilePic.contentMode = .scaleAspectFill
                        self.profilePic.loadImageUsingCacheWithURLString(urlString: profileImageURL)
                    }
                }
            }
        }
    }
    
}

