//
//  FollowersFollowing.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/24/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Foundation

class FollowersFollowing: UIView {

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
        contentView.constrainEdges(to: self)
        backgroundColor = UIColor.clear
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
        UserFirebaseMethods.retriveFollowingUsers { (users) in
            self.numFollowers.text = String(users.count)
            
        }
    }
    
    func populateFollowingLabel() {
        UserFirebaseMethods.retriveFollowingUsers { (users) in
            self.numFollowing.text = String(users.count)
        }
    }
    
    func populatePostsLabel() {
        PostsFirebaseMethods.downloadUsersBookPostsArray { (booksPosted) in
            self.booksPosted.text = String(booksPosted.count)
        }
    }
    
}

