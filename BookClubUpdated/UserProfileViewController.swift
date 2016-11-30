//
//  UserProfileViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
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
    var userPosts = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewWidth = view.frame.width
        let followersFollowingViewHeight = view.frame.height.multiplied(by: 0.25)
        
        let followersFollowingView = FollowersFollowing(frame: CGRect(x: 0, y: 20, width: viewWidth, height: followersFollowingViewHeight))
        view.addSubview(followersFollowingView)
        
        postsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        postsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        postsCollectionView.topAnchor.constraint(equalTo: followersFollowingView.bottomAnchor).isActive = true
        postsCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        followersFollowingView.followersButtonOutlet.addTarget(self, action: #selector(segueToFollowers), for: .touchDown)
        
        
        followersFollowingView.followingButtonOutlet.addTarget(self, action: #selector(segueToFollowing), for: .touchDown)
        
        
        self.cellConfig()
        
        PostsFirebaseMethods.downloadUsersBookPostsLinkIDArray { (bookLinkArray, bookIDArray) in
            self.userPosts = bookLinkArray
            self.postsCollectionView.reloadData()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        PostsFirebaseMethods.downloadUsersBookPostsLinkIDArray { (bookLinkArray, bookIDArray) in
            self.userPosts = bookLinkArray
            self.postsCollectionView.reloadData()
        }
    }
    
    
    func cellConfig() {
        let screedWidth = UIScreen.main.bounds.width
        let screenHeight = postsCollectionView.frame.height
        
        let numOfRows = CGFloat(3.0)
        let numOfColumns = CGFloat(3.0)
        
        insetSpacing = 2
        minimumInterItemSpacing = 2
        minimumLineSpacing = 2
        sectionInsets = UIEdgeInsetsMake(insetSpacing, insetSpacing, insetSpacing, insetSpacing)
        referenceSize = CGSize(width: screedWidth, height: 0)
        
        let totalWidthDeduction = (minimumInterItemSpacing + minimumInterItemSpacing + sectionInsets.right + sectionInsets.left)
        let totalHeightDeduction = (sectionInsets.right + sectionInsets.left + minimumLineSpacing + minimumLineSpacing)
        
        
        itemSize = CGSize(width: (screedWidth/numOfColumns) - (totalWidthDeduction/numOfColumns), height: (screenHeight - totalHeightDeduction)/3)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserPostCollectionViewCell
        
//        let imageLink = userPosts[indexPath.item]
//        let imageURL = URL(string: imageLink)
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.black.cgColor
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
