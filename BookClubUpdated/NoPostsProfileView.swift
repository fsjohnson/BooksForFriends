//
//  NoPostsProfileView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 1/1/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit

class NoPostsProfileView: UIView {

    @IBOutlet var contentView: UIView!
    var instructionsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NoPostsProfileView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.constrainEdges(to: self)
        
        let backgroundLayer = CALayer.makeGradient(firstColor: UIColor.themeLightBlue, secondColor: UIColor.themeDarkBlue)
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.contentView.layer.addSublayer(backgroundLayer)
        
        instructionsLabel.text = "This is your profile! You can change your profile picture by clicking the photo above. You can also see who you are following and your followers by clicking on the buttons above. To search and post a book for your followers to see, click the icon on the top right corner."
        instructionsLabel.numberOfLines = 0
        instructionsLabel.lineBreakMode = .byWordWrapping
        instructionsLabel.textAlignment = .center
        instructionsLabel.textColor = UIColor.themeWhite
        instructionsLabel.font = UIFont.themeMediumBold
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(instructionsLabel)
        instructionsLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        instructionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        instructionsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        instructionsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}

