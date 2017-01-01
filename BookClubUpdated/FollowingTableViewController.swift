//
//  FollowingTableViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/24/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class FollowingTableViewController: UITableViewController {
    
    var followingArray = [User]()
    //var array = [User]()
    var uniqueUserIDs = [String]()
    var deleteButtonSelected = false
    var passedUserID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        UserFirebaseMethods.retriveFollowingUsers(with: passedUserID) { (users) in
            self.followingArray = users ?? []
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingCell", for: indexPath) as! FollowingTableViewCell
        cell.textLabel?.text = followingArray[indexPath.row].username
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.unfollowFriend(at: indexPath.row)
            followingArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func unfollowFriend(at indexPath: Int) {
        let userUniqueKey = followingArray[indexPath].uniqueKey
        let username = followingArray[indexPath].username
        
        UserFirebaseMethods.removeFollowing(with: userUniqueKey) {
            let alert = UIAlertController(title: "Success", message: "You have unfollowed \(username)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.deleteButtonSelected = false
                self.tableView.reloadData()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
