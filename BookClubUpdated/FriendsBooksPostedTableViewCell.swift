//
//  FriendsBooksPostedTableViewCell.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/25/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class FriendsBooksPostedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postView: PostsView!
    
    var bookID: String!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
