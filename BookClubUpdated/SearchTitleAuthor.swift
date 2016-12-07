//
//  SearchTitleAuthor.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/7/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class SearchTitleAuthor: UIView {

    @IBOutlet weak var searchTitle: UISearchBar!
    @IBOutlet weak var searchAuthor: UISearchBar!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
