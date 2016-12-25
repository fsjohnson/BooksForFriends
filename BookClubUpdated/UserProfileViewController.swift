//
//  UserProfileViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase
import DropDown


protocol GetUser {
    func getUser(with user: User)
}

class UserProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, GetUser {
    
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    let dropDown = DropDown()
    
    @IBOutlet weak var dropDownOutlet: UIBarButtonItem!
    
    
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
    var currentUser: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary

        configFirebaseData()
        configFollowersFollowingView()
        configSegmentedControl()
        dropdownMenuConfig()
        self.cellConfig()
        
        postsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        postsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        postsCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: segmentedControl.bounds.height.multiplied(by: 0.1)).isActive = true
        postsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        postsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        postsCollectionView.register(UserPostCollectionViewCell.self, forCellWithReuseIdentifier: "bookPost")
        
        view.addSubview(postsCollectionView)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        PostsFirebaseMethods.downloadUsersBookPostsArray(with: currentUserID) { (booksPosted) in
            self.userPosts = booksPosted ?? []
            self.postsCollectionView.reloadData()
        }
        
        segmentedControl.selectedSegmentIndex = 0
        followersFollowingView.populatePostsLabel()
        followersFollowingView.populateFollowersLabel()
        followersFollowingView.populateFollowingLabel()
    }

    func configFirebaseData() {
        
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        UserFirebaseMethods.retrieveSpecificUser(with: currentUserID) { (returnedUser) in
            guard let username = returnedUser?.username else { print("no username"); return }
            self.navigationItem.title = "\(username)'s Posts"
            guard let user = returnedUser else { return }
            self.getUser(with: user)
            self.currentUser = user
        }
        
        
        PostsFirebaseMethods.downloadUsersBookPostsArray(with: currentUserID) { (booksPosted) in
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
        followersFollowingView = FollowersFollowing(frame: CGRect(x: 0, y: -navBarHeight, width: viewWidth, height: followersFollowingViewHeight))
        view.addSubview(followersFollowingView)
        followersFollowingView.profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        followersFollowingView.followersButtonOutlet.addTarget(self, action: #selector(segueToFollowers), for: .touchDown)
        followersFollowingView.followingButtonOutlet.addTarget(self, action: #selector(segueToFollowing), for: .touchDown)
        
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
    
    func dropdownMenuConfig() {
        
        dropDown.anchorView = dropDownOutlet
        dropDown.dataSource = ["Change username","Contact BFF", "Logout"]
        dropDown.width = 200
        dropDown.direction = .any
        
        dropDown.textColor = UIColor.themeDarkBlue
        dropDown.textFont = UIFont.themeTinyBold!
        dropDown.backgroundColor = UIColor.themeWhite
        dropDown.selectionBackgroundColor = UIColor.themeLightBlue
        dropDown.cornerRadius = 5
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if index == 0 {
                self.changeUsername()
            } else if index == 1 {
                self.contactBFFAlert()
            } else if index == 2 {
                self.logoutButton()
            }
        }
    }
    
    func logoutButton() {
        do {
            try FIRAuth.auth()?.signOut()
            
        } catch {
            print(error)
        }
        
        if let storyboard = self.storyboard {
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginVC, animated: false, completion: nil)
        }
        
    }
    
    
    func contactBFFAlert() {
        
        guard (FIRAuth.auth()?.currentUser?.uid) != nil else { return }
        
        let alert = UIAlertController(title: "Feedback for BFF?", message: "Type your comments or questions here!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (reviewTextField) in
            reviewTextField.text = "" }
        
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            
            UserFirebaseMethods.sendFeedbackToBFF(with: reviewTextField.text!)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeUsername() {
        
        guard let userID = FIRAuth.auth()?.currentUser?.uid else { return }
        let alert = UIAlertController(title: "Want to change your username?", message: "Type new username here!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (usernameTextField) in
            usernameTextField.text = "" }
        
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let usernameTextField = alert.textFields![0]
            
            UserFirebaseMethods.changeUsername(with: userID, username: usernameTextField.text!, completion: {
                let alert = UIAlertController(title: "Success!", message: "You have updated your username", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    UserFirebaseMethods.retrieveSpecificUser(with: userID) { (returnedUser) in
                        guard let username = returnedUser?.username else { print("no username"); return }
                        self.navigationItem.title = "\(username)'s Posts"
                    }
                    
                }))

                self.present(alert, animated: true, completion: nil)
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
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
    
    
    @IBAction func addBookBtn(_ sender: Any) {
        performSegue(withIdentifier: "addBookSegue", sender: self)
    }
    
    
    func segmentedControlSegues(sender: UISegmentedControl!) {
        
        if sender.selectedSegmentIndex == 1 {
            self.performSegue(withIdentifier: "viewList", sender: self)
        }
        
    }
    
    func segueToFollowers() {
        self.performSegue(withIdentifier: "followersSegue", sender: self)
    }
    
    func segueToFollowing() {
        self.performSegue(withIdentifier: "followingSegue", sender: self)
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "followersSegue" {
            let dest = segue.destination as! FollowersTableViewController
            dest.passedUserID = currentUser.uniqueKey
            
        }
        
        if segue.identifier == "followingSegue" {
            let dest = segue.destination as! FollowingTableViewController
            dest.passedUserID = currentUser.uniqueKey
            
        }
        
        if segue.identifier == "viewList" {
            guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
            let destination = segue.destination as! UINavigationController
            let finalDest = destination.topViewController as! UserPostListTableViewController
            finalDest.passedUserUniqueID = currentUserID
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
    
    
    @IBAction func dropDown(_ sender: Any) {
        
        dropDown.show()
        
    }

}
