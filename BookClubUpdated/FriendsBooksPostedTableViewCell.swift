//
//  FriendsBooksPostedTableViewCell.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/25/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class FriendsBooksPostedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
