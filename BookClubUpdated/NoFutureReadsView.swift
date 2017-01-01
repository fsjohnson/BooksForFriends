//
//  NoFutureReadsView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 1/1/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit

class NoFutureReadsView: UIView {

    @IBOutlet var contentView: UIView!
    var explanationLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NoFutureReadsView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.constrainEdges(to: self)
        
        let backgroundLayer = CALayer.makeGradient(firstColor: UIColor.themeLightBlue, secondColor: UIColor.themeDarkBlue)
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.contentView.layer.addSublayer(backgroundLayer)
        
        explanationLabel.text = "Find all the books that you have selected to read in the future here. Click on the image to be reminded of the synopsis, post the book after having read it, and delete the book if you decide you no longer want to read it."
        explanationLabel.numberOfLines = 0
        explanationLabel.lineBreakMode = .byWordWrapping
        explanationLabel.textAlignment = .center
        explanationLabel.textColor = UIColor.themeWhite
        explanationLabel.font = UIFont.themeMediumBold
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(explanationLabel)
        explanationLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        explanationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        explanationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        explanationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
