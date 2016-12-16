//
//  BooksFriendsReadTableViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class BooksFriendsReadTableViewController: UITableViewController {
    
    
    var postsArray = [BookPosted]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        PostsFirebaseMethods.downloadFollowingPosts { (postsArray) in
            self.postsArray = postsArray
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PostsFirebaseMethods.downloadFollowingPosts { (postsArray) in
            self.postsArray = postsArray
            self.tableView.reloadData()
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "getBookDetails", sender: self)
    }
    
    
    func canDisplayImage(sender: BookPosted) -> Bool {
        
        let viewableCells = tableView.visibleCells as! [FriendsBooksPostedTableViewCell]
        
        for cell in viewableCells {
            
            if cell.bookID == sender.bookUniqueID { return true }
            
        }
        
        return false
        
    }
    
    
    func flagButtonTouched(sender: UIButton) {
        
        print("button touched")
        
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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
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


