//
//  UserProfileViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewWidth = view.frame.width
        let viewHeight = view.frame.height
        
        let followersFollowingView = FollowersFollowing(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        view.addSubview(followersFollowingView)
        
//        segueToFollowers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addBookBtn(_ sender: Any) {
        print("BUTTON PRESSED")
        performSegue(withIdentifier: "addBookSegue", sender: self)
    }
   
    
    
    func segueToFollowers() {
        let followersVC = storyboard?.instantiateViewController(withIdentifier: "FollowersTableViewController")
        self.present(followersVC!, animated: true, completion: nil)
    }
    
    func segueToFollowing() {
        let followingVC = storyboard?.instantiateViewController(withIdentifier: "FollowingTableViewController")
        self.present(followingVC!, animated: true, completion: nil)
    }


    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "followersSegue" {
            let dest = segue.destination as! FollowersTableViewController
        }
        
        if segue.identifier == "followingSegue" {
            let dest = segue.destination as! FollowingTableViewController
        }
    }


}
