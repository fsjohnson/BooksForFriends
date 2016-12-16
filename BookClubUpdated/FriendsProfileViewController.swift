//
//  FriendsProfileViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/15/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase
import DropDown


class FriendsProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, GetUser {
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    var convertedImage: UIImage!
    var insetSpacing: CGFloat!
    var minimumInterItemSpacing: CGFloat!
    var minimumLineSpacing: CGFloat!
    var userPosts = [BookPosted]()
    var segmentedControl = UISegmentedControl(items: ["Icons", "List"])
    var followersFollowingView: FollowersFollowing!
    var passedUserID = String()
    var friendUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        configFollowersFollowingView()
        configFirebaseData()
        configSegmentedControl()
        self.cellConfig()
        
        postsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        postsCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: segmentedControl.bounds.height.multiplied(by: 0.1)).isActive = true
        postsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        postsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        postsCollectionView.register(UserPostCollectionViewCell.self, forCellWithReuseIdentifier: "bookPost")
        view.addSubview(postsCollectionView)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    
        PostsFirebaseMethods.downloadUsersBookPostsArray(with: passedUserID) { (booksPosted) in
            print("PASSED ID: \(self.passedUserID)")
            print("books count: \(booksPosted?.count)")
            self.userPosts = booksPosted ?? []
            self.postsCollectionView.reloadData()
        }
        
        segmentedControl.selectedSegmentIndex = 0
        followersFollowingView.populatePostsLabel()
        followersFollowingView.populateFollowersLabel()
        followersFollowingView.populateFollowingLabel()
    }
    
    func configFirebaseData() {
        
        UserFirebaseMethods.retrieveSpecificUser(with: passedUserID) { (returnedUser) in
            guard let username = returnedUser?.username else { print("no username"); return }
            self.navigationItem.title = "\(username)'s Posts"
            guard let user = returnedUser else { return }
            self.getUser(with: user)
            self.friendUser = user
        }
        
        PostsFirebaseMethods.downloadUsersBookPostsArray(with: passedUserID) { (booksPosted) in
            self.userPosts = booksPosted ?? []
            self.postsCollectionView.reloadData()
        }
        
    }
    
    func getUser(with user: User) {
        followersFollowingView.user = user
    }
    
    func configFollowersFollowingView() {
        
        guard let navBarHeight = self.navigationController?.navigationBar.frame.height else { print("no nav bar height"); return }
        
        let viewWidth = view.frame.width
        let followersFollowingViewHeight = view.frame.height.multiplied(by: 0.15)
        followersFollowingView = FollowersFollowing(frame: CGRect(x: 0, y: navBarHeight.multiplied(by: 1.5), width: viewWidth, height: followersFollowingViewHeight))
        view.addSubview(followersFollowingView)
        followersFollowingView.followersButtonOutlet.isUserInteractionEnabled = false
        followersFollowingView.followingButtonOutlet.isUserInteractionEnabled = false
        
    }
    
    
    func configSegmentedControl() {
        
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: followersFollowingView.bottomAnchor, constant: followersFollowingView.bounds.height.multiplied(by: 0.1)).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlSegues), for: .valueChanged)
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.themeDarkBlue], for: .normal)
        segmentedControl.tintColor = UIColor.themeDarkBlue
        
    }

    func cellConfig() {
        let screedWidth = view.frame.width
        let screenHeight = view.frame.height
        
        let numOfRows = CGFloat(4.0)
        let numOfColumns = CGFloat(3.0)
        
        insetSpacing = 2
        minimumInterItemSpacing = 2
        minimumLineSpacing = 2
        sectionInsets = UIEdgeInsetsMake(insetSpacing, insetSpacing, insetSpacing, insetSpacing)
        referenceSize = CGSize(width: screedWidth, height: 0)
        
        let totalWidthDeduction = (minimumInterItemSpacing + minimumInterItemSpacing + sectionInsets.right + sectionInsets.left)
        let totalHeightDeduction = (sectionInsets.right + sectionInsets.left + minimumLineSpacing + minimumLineSpacing)
        
        
        itemSize = CGSize(width: (screedWidth - totalWidthDeduction)/numOfColumns, height: (screenHeight - totalHeightDeduction)/numOfRows)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentedControlSegues(sender: UISegmentedControl!) {
        
        if sender.selectedSegmentIndex == 1 {
            self.performSegue(withIdentifier: "viewList", sender: self)
        }
        
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewList" {
            let finalDest = segue.destination as! UserPostListTableViewController
            finalDest.passedUserUniqueID = friendUser.uniqueKey
        }
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userPosts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookPost", for: indexPath) as! UserPostCollectionViewCell
        let currentPost = userPosts[indexPath.row]
        print("Cureent post: \(currentPost)")
        cell.configureCell(book: currentPost)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}
