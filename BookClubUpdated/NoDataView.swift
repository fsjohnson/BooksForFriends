//
//  NoDataView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/25/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    @IBOutlet var contentView: UIView!
    var welcomeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.constrainEdges(to: self)

        let backgroundLayer = CALayer.makeGradient(firstColor: UIColor.themeLightBlue, secondColor: UIColor.themeDarkBlue)
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.contentView.layer.addSublayer(backgroundLayer)
        
        welcomeLabel.text = "Welcome to BFF! Here is where you will see the books your friends have posted. You can select the post to read the book's synopsis and to add it to your list of future reads. Find friends to follow on the \"Search Friends\" tab. Check out your profile and post your own recent reads on the \"Profile\" tab. Happy reading & sharing!"
        welcomeLabel.numberOfLines = 0
        welcomeLabel.lineBreakMode = .byWordWrapping
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = UIColor.themeWhite
        welcomeLabel.font = UIFont.themeMediumBold
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(welcomeLabel)
        welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        welcomeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
    }
}


// MARK: - UIView Extension
extension UIView {
    
    func constrainToEdges(view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
