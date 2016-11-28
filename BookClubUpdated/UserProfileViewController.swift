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
        let viewHeight = view.frame.height.multiplied(by: 0.25)
        
        let followersFollowingView = FollowersFollowing(frame: CGRect(x: 0, y: 20, width: viewWidth, height: viewHeight))
        view.addSubview(followersFollowingView)
        
        
        followersFollowingView.followersButtonOutlet.addTarget(self, action: #selector(segueToFollowers), for: .touchDown)
        
    
        followersFollowingView.followingButtonOutlet.addTarget(self, action: #selector(segueToFollowing), for: .touchDown)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addBookBtn(_ sender: Any) {
        performSegue(withIdentifier: "addBookSegue", sender: self)
    }
   
    
    
    func segueToFollowers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "FollowersTableViewController") as UIViewController
        self.present(destVC, animated: true, completion: nil)
    }
    
    func segueToFollowing() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "FollowingTableViewController") as UIViewController
        self.present(destVC, animated: true, completion: nil)
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
