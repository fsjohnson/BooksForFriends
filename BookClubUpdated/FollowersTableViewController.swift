//
//  FollowersTableViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/24/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class FollowersTableViewController: UITableViewController {
    
    var followersArray = [User]()
    var deleteButtonSelected = false
    var passedUserID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        UserFirebaseMethods.retriveFollowers(with: passedUserID) { (users) in
            guard let array = users else { return }
            for user in array {
                self.followersArray.append(user)
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell", for: indexPath)
        cell.textLabel?.text = followersArray[indexPath.row].username

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.blockUser(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Block"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func blockUser(at indexPath: Int) {
        
        let userToRemove = followersArray[indexPath].uniqueKey
        let friend = followersArray[indexPath].username
        
        UserFirebaseMethods.blockFollower(with: userToRemove) {
            let alert = UIAlertController(title: "Success!", message: "You have blocked \(friend)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.followersArray.remove(at: indexPath)
                self.deleteButtonSelected = false
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
