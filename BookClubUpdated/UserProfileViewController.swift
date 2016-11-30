//
//  UserProfileViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navBarHeight = self.navigationController?.navigationBar.frame.height else { print("no nav bar height"); return }

        
        let viewWidth = view.frame.width
        let followersFollowingViewHeight = view.frame.height.multiplied(by: 0.15)
        
        let followersFollowingView = FollowersFollowing(frame: CGRect(x: 0, y: navBarHeight, width: viewWidth, height: followersFollowingViewHeight))
        view.addSubview(followersFollowingView)
        
        view.addSubview(postsCollectionView)
        
        postsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        postsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        postsCollectionView.topAnchor.constraint(equalTo: followersFollowingView.bottomAnchor).isActive = true
        postsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        postsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        postsCollectionView.layer.borderWidth = 2.0
//        postsCollectionView.layer.borderColor = UIColor.black.cgColor
        
        postsCollectionView.register(UserPostCollectionViewCell.self, forCellWithReuseIdentifier: "bookPost")
        
        followersFollowingView.followersButtonOutlet.addTarget(self, action: #selector(segueToFollowers), for: .touchDown)
        
        
        followersFollowingView.followingButtonOutlet.addTarget(self, action: #selector(segueToFollowing), for: .touchDown)
        
        
        self.cellConfig()
        
        PostsFirebaseMethods.downloadUsersBookPostsArray { (booksPosted) in
            self.userPosts = booksPosted
            self.postsCollectionView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        PostsFirebaseMethods.downloadUsersBookPostsArray { (booksPosted) in
            self.userPosts = booksPosted
            self.postsCollectionView.reloadData()
        }
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
    
    
    
    func segueToFollowers() {
        self.performSegue(withIdentifier: "followersSegue", sender: self)
    }
    
    func segueToFollowing() {
        self.performSegue(withIdentifier: "followingSegue", sender: self)
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "followersSegue" {
            let destinationNavController = segue.destination as! FollowersTableViewController
            
        }
        
        if segue.identifier == "followingSegue" {
            let destinationNavController = segue.destination as! FollowingTableViewController
            
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
        cell.bookPost = currentPost
        
        
        
//        
//        guard let imageLink = String(userPosts[indexPath.item].imageLink) else {return cell}
//        let imageURL = URL(string: imageLink)
//        guard let data = try? Data(contentsOf: imageURL!) else {
//            cell.imageView.image = UIImage(named: "BFFLogo")
//            return cell
//        }
//        
//        cell.imageView.image = UIImage(data: data)

        
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
