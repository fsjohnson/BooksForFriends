//
//  BooksFriendsReadTableViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import SystemConfiguration

class BooksFriendsReadTableViewController: UITableViewController {
    
    var store = BFFCoreData.sharedInstance
    var postsArray = [BookPosted]()
    var noDataView: NoDataView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("VIEW DID LOAD")
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        guard let navBarHeight = self.navigationController?.navigationBar.frame.height else { print("no nav bar height"); return }
        self.noDataView = NoDataView(frame: CGRect(x: 0, y: -navBarHeight, width: self.view.frame.width, height: self.view.frame.height))
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        
        
        if Reachability.isConnectedToNetwork() == true {
            self.store.deleteData()
            PostsFirebaseMethods.downloadFollowingPosts(with: currentUser) { (postsArray) in
                self.postsArray = postsArray
                self.savePostsData(with: currentUser, postsArray: postsArray)
                self.tableView.reloadData()
            }
        } else {
            self.postsArray.removeAll()
            store.fetchData()
            for post in store.posts {
                guard let bookUniqueID = post.bookUniqueID else { let bookUniqueID = "no id";return }
                guard let comment = post.comment else { return }
                guard let imageLink = post.imageLink else { return }
                guard let reviewID = post.reviewID else { return }
                guard let userUniqueKey = post.userUniqueKey else { return }
                guard let bookTitle = post.bookTitle else { return }
                
                let newBook = BookPosted(bookUniqueID: bookUniqueID, rating: String(post.rating), comment: comment, imageLink: imageLink, timestamp: post.timestamp, userUniqueKey: userUniqueKey, reviewID: reviewID, title: bookTitle)
                postsArray.append(newBook)
                tableView.reloadData()
            }
        }
        
        UserFirebaseMethods.checkIfFollowingUsersIsEmpty { (isEmpty) in
            if isEmpty == true {
                self.view.addSubview(self.noDataView)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIEW WILL APPEAR")
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        
        if Reachability.isConnectedToNetwork() == true  {
            self.store.deleteData()
            PostsFirebaseMethods.downloadFollowingPosts(with: currentUser) { (postsArray) in
                if self.postsArray.count != postsArray.count {
                    self.savePostsData(with: currentUser, postsArray: postsArray)
                }
                self.postsArray = postsArray
                self.tableView.reloadData()
            }
        }
        
        UserFirebaseMethods.checkIfFollowingUsersIsEmpty { (isEmpty) in
            if isEmpty == true {
                self.view.addSubview(self.noDataView)
            } else {
                if self.view.subviews.contains(self.noDataView) {
                    self.noDataView.removeFromSuperview()
                }
            }
        }
    }
    
    func savePostsData(with currentUser: String, postsArray: [BookPosted]) {
        let managedContext = BFFCoreData.sharedInstance.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Post", in: managedContext)
        
        if let unwrappedEntity = entity {
            for item in postsArray {
                let newPost = NSManagedObject(entity: unwrappedEntity, insertInto: managedContext) as! Post
                newPost.bookTitle = item.title
                newPost.comment = item.comment
                newPost.imageLink = item.imageLink
                newPost.rating = Float(item.rating)!
                newPost.userName = item.username
                newPost.bookUniqueID = item.bookUniqueID
                newPost.reviewID = item.reviewID
                newPost.timestamp = item.timestamp
                newPost.userUniqueKey = item.userUniqueKey
                self.store.saveContext()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "booksPosted", for: indexPath) as! FriendsBooksPostedTableViewCell
        
        if cell.postView.delegate == nil { cell.postView.delegate = self }
        cell.postView.bookPost = postsArray[indexPath.row]
        cell.postView.flagButtonOutlet.tag = indexPath.row
        cell.postView.starView.isUserInteractionEnabled = false
        cell.postView.flagButtonOutlet.addTarget(self, action: #selector(flagButtonTouched), for: .touchUpInside)
        
        return cell
    }
    
    func canDisplayImage(sender: BookPosted) -> Bool {
        
        let viewableCells = tableView.visibleCells as! [FriendsBooksPostedTableViewCell]
        for cell in viewableCells {
            if cell.bookID == sender.bookUniqueID { return true }
        }
        return false
    }
    
    
    func flagButtonTouched(sender: UIButton) {
        
        let index = sender.tag
        let flaggedPost = postsArray[index]
        
        PostsFirebaseMethods.flagPostsWith(book: flaggedPost) {
            let alert = UIAlertController(title: "Are you sure?", message: "Do you want to flag this comment?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.postsArray.remove(at: index)
                self.tableView.reloadData()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getBookDetails" {
            let targetController = segue.destination as! BookDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let bookUniqueID = postsArray[indexPath.row].bookUniqueID
                let imageLinkToPass = postsArray[indexPath.row].imageLink
                targetController.passedUniqueID = bookUniqueID
                targetController.passedImageLink = imageLinkToPass
                
            }
        }
    }
}


// Mark: - Presentation Methods

extension BooksFriendsReadTableViewController: BookPostDelegate {
    
    func canDisplayImage(sender: PostsView) -> Bool {
        
        guard let viewableIndexPaths = tableView.indexPathsForVisibleRows else { return false }
        var books: Set<BookPosted> = []
        for indexPath in viewableIndexPaths {
            let currentBook = postsArray[indexPath.row]
            books.insert(currentBook)
        }
        return books.contains(sender.bookPost)
    }
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
    }
}


