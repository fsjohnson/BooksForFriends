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

class BooksFriendsReadTableViewController: UITableViewController {
    
    var store = BookClubUpdated.sharedInstance
    var postsArray = [BookPosted]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        PostsFirebaseMethods.downloadFollowingPosts(with: currentUser) { (postsArray) in
            self.postsArray = postsArray
            self.tableView.reloadData()
        }
        
        savePostsData()
        
        if postsArray.isEmpty {
            store.fetchData()
            postsArray = store.posts
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        PostsFirebaseMethods.downloadFollowingPosts(with: currentUser) { (postsArray) in
            self.postsArray = postsArray
            self.tableView.reloadData()
        }
        
        savePostsData()
        if postsArray.isEmpty {
            store.fetchData()
            postsArray = store.posts
            tableView.reloadData()
        }
    }
    
    func savePostsData() {
        let managedContext = BookClubUpdated.sharedInstance.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Post", in: managedContext)
        
        if let unwrappedEntity = entity {
            let newPost = NSManagedObject(entity: unwrappedEntity, insertInto: managedContext) as! Post
            PostsFirebaseMethods.downloadFollowingPosts(with: currentUser) { (postsArray) in
                for item in postsArray {
                    newPost.bookTitle = item.title
                    newPost.comment = item.comment
                    newPost.imageLink = item.imageLink
                    newPost.rating = item.rating
                    newPost.userName = item.username
                    store.saveContext()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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


