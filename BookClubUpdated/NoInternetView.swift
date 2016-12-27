//
//  NoInternetView.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/27/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class NoInternetView: UIView {

    @IBOutlet var contentView: UIView!
    var noInternetLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NoInternetView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.constrainEdges(to: self)
        
        let backgroundLayer = CALayer.makeGradient(firstColor: UIColor.themeLightBlue, secondColor: UIColor.themeDarkBlue)
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.contentView.layer.addSublayer(backgroundLayer)
        
        noInternetLabel.text = "No internet connection"
        noInternetLabel.numberOfLines = 0
        noInternetLabel.textAlignment = .center
        noInternetLabel.textColor = UIColor.themeWhite
        noInternetLabel.font = UIFont.themeMediumBold
        noInternetLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(noInternetLabel)
        noInternetLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        noInternetLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        noInternetLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        noInternetLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}


// MARK: - UIView Extension
extension UIView {
    
    func constrainEdges(view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}
