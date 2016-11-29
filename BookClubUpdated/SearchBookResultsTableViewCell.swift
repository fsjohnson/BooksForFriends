//
//  SearchBookResultsTableViewCell.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/21/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class SearchBookResultsTableViewCell: UITableViewCell {
    
    var searchResultView: SearchResultsView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "bookResult")
        
        
        
        searchResultView = SearchResultsView(frame: CGRect.zero)
        configureView()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
   
    }

    
    private func configureView() {
        
        addSubview(searchResultView)
        searchResultView.translatesAutoresizingMaskIntoConstraints = false
        searchResultView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        searchResultView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        searchResultView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        searchResultView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }

}
