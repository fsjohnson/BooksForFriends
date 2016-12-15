//
//  UserPostListTableViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/4/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class UserPostListTableViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var userPosts = [BookPosted]()
    var passedUserUniqueID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
                
        PostsFirebaseMethods.downloadUsersBookPostsArray(with: passedUserUniqueID) { (posts) in
            self.userPosts = posts ?? []
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userPost", for: indexPath) as! UserPostListTableViewCell
        if cell.postView.delegate == nil { cell.postView.delegate = self }
        cell.postView.bookPost = userPosts[indexPath.row]
        cell.postView.flagButtonOutlet.addTarget(self, action: #selector(flagButtonTouched), for: .touchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func flagButtonTouched(sender: UIButton) {

        let index = sender.tag
        let flaggedPost = userPosts[index]
        
        PostsFirebaseMethods.flagPostsWith(book: flaggedPost) {
            let alert = UIAlertController(title: "Are you sure?", message: "Do you want to flag this comment?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.userPosts.remove(at: index)
                self.tableView.reloadData()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}




extension UserPostListTableViewController: BookPostDelegate {
    
    func canDisplayImage(sender: PostsView) -> Bool {
        
        guard let viewableIndexPaths = tableView.indexPathsForVisibleRows else { return false }
        
        var books: Set<BookPosted> = []
        
        for indexPath in viewableIndexPaths {
            
            let currentBook = userPosts[indexPath.row]
            
            books.insert(currentBook)
            
        }
        
        return books.contains(sender.bookPost)
        
    }
    
    
}


