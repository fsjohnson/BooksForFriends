//
//  CustomTextField.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/8/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(10, 10, 10, 10)))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(10, 10, 10, 10)))
    }
}

