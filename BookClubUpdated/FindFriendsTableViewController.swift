//
//  FindFriendsTableViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/24/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class FindFriendsTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredUsers = [User]()
    var usersArray = [User]()
    var usernamesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
        UserFirebaseMethods.retrieveAllUsers { (users) in
            for user in users {
                guard let addedUser = user else {return}
                self.usersArray.append(addedUser)
                self.usernamesArray.append(addedUser.username)
                self.tableView.reloadData()
            }
        }
    }
    
    
    func filterContentForSearchText(searchText: String) {
        
        filteredUsers = usersArray.filter { user in
            print("USER: \(user.username)")
            return user.username.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && self.searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return usersArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResults", for: indexPath) as! SearchFriendsTableViewCell
        
        let user: User
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        } else {
            user = usersArray[indexPath.row]
        }
        cell.textLabel?.text = user.username
        
        cell.addFollowing.addTarget(self, action: #selector(addFollowingButton), for: .touchUpInside)
        
        return cell
    }
    
    func addFollowingButton(sender: UIButton) {
        _ = sender.tag
        
        print("BUTTON TAPPED")
        
        let cellContent = sender.superview!
        let cell = cellContent.superview! as! UITableViewCell
        guard let indexPath = self.tableView.indexPath(for: cell) else {return}
        
        var uniqueUserID = String()
        var username = String()
        
        if searchController.isActive && searchController.searchBar.text != "" {
            uniqueUserID = filteredUsers[indexPath.row].uniqueKey
            username = filteredUsers[indexPath.row].username
        } else {
            uniqueUserID = usersArray[indexPath.row].uniqueKey
            username = usersArray[indexPath.row].username
        }
        
        UserFirebaseMethods.retrieveSpecificUser(with: uniqueUserID) { (user) in
            
            UserFirebaseMethods.prohibitDuplicateFollowing(of: uniqueUserID, completion: { (alreadyFollowing) in
                if alreadyFollowing == true {
                    let alert = UIAlertController(title: "Oops", message: "You are already following \(username)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    UserFirebaseMethods.addFollowing(with: uniqueUserID, completion: { (success) in
                        if success == true {
                            
                            let alert = UIAlertController(title: "Success", message: "You have added \(username) as a friend!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in

                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Oops", message: "You have been blocked by \(username)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
       
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    })
                }
            })
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
        
        if segue.identifier == "userPostDetail" {
            let dest = segue.destination as! UINavigationController
            let target = dest.topViewController as! UserPostListTableViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
               target.passedUserUniqueID = usersArray[indexPath.row].uniqueKey
            }
        }
        
        
     }
 
    
}


extension FindFriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        print(searchController.searchBar.text!)
    }
}

