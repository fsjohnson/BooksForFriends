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

        PostsFirebaseMethods.downloadAllPosts { (postsArray) in
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

        cell.usernameLabel.text = postsArray[indexPath.row].userUniqueKey
        cell.commentsLabel.text = postsArray[indexPath.row].comment
        cell.bookImage.image = postsArray[indexPath.row].bookCover

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "getBookDetails", sender: self)
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
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! BookDetailsViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let bookUniqueID = postsArray[indexPath.row].bookUniqueID
                let imageLinkToPass = postsArray[indexPath.row].imageLink
                guard let bookCoverToPass = postsArray[indexPath.row].bookCover else {print("no cover"); return}
                
                targetController.passedImage = bookCoverToPass
                targetController.passedUniqueID = bookUniqueID
                targetController.passedImageLink = imageLinkToPass
                
            }
        }
    }
 

}
