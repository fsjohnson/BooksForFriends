//
//  UserPostListTableViewCell.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/4/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class UserPostListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postView: PostsView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func configureView() {
        
        addSubview(postView)
        postView.translatesAutoresizingMaskIntoConstraints = false
        postView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        postView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        postView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        postView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }


}
