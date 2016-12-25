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
    @IBOutlet weak var welcomeLabel: UILabel!
    
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
        backgroundColor = UIColor.clear
        
        welcomeLabel.textColor = UIColor.themeLightBlue
        welcomeLabel.font = UIFont.themeMediumBold
        
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
