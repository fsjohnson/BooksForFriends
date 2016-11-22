//
//  SearchBookResultsTableViewCell.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/21/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class SearchBookResultsTableViewCell: UITableViewCell {

    var bookTitleLabel = UILabel()
    var bookAuthorLabel = UILabel()
    var bookImage = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "bookResult")
        
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureCell() {
        
        // book title label
        
        addSubview(bookTitleLabel)
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        
        
        // book author label
        
        addSubview(bookAuthorLabel)
        bookAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(authorLabel)
        authorLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        
        
        // title labels stackView
        
        let titleStackView = UIStackView()
        titleStackView.axis  = UILayoutConstraintAxis.vertical
        titleStackView.distribution  = UIStackViewDistribution.equalSpacing
        titleStackView.alignment = UIStackViewAlignment.fill
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(authorLabel)
        titleStackView.translatesAutoresizingMaskIntoConstraints = false;
        titleStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        titleStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.90)
        
        self.addSubview(titleStackView)
        titleStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        
        
        // book info stackView
        
        let stackView = UIStackView()
        stackView.axis  = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.fill

        stackView.addArrangedSubview(bookTitleLabel)
        stackView.addArrangedSubview(bookAuthorLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.90)
        
        self.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: titleStackView.rightAnchor, constant: 10).isActive = true
        
        // book image
        
        addSubview(bookImage)
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        bookImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        bookImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        bookImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.90).isActive = true
        bookImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        bookImage.contentMode = UIViewContentMode.scaleAspectFit

        
    }


}
