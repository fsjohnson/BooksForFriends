//
//  CustomColor.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/3/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public static let themeOrange = UIColor(red: 240 / 255, green: 125 / 255, blue: 50 / 255, alpha: 1)
    public static let themeLightGrey = UIColor(red: 46 / 255, green: 46 / 255, blue: 46 / 255, alpha: 1)
    public static let themeDarkGrey = UIColor(red: 36 / 255, green: 36 / 255, blue: 36 / 255, alpha: 1)
    public static let themeWhite = UIColor(red: 229 / 255, green: 229 / 255, blue: 229 / 255, alpha: 1)
    public static let themeBlack = UIColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)
    public static let themeDarkBlue = UIColor(red: 1 / 255, green: 13 / 255, blue: 38 / 255, alpha: 1)
    public static let themeLightBlue = UIColor(red: 143 / 255, green: 159 / 255, blue: 191 / 255, alpha: 1)
}

// MARK: Gradients
extension CAGradientLayer {
    convenience init(_ colors: [UIColor]) {
        self.init()
        
        self.colors = colors.map { $0.cgColor }
    }
}

extension CALayer {
    public static func makeGradient(firstColor: UIColor, secondColor: UIColor) -> CAGradientLayer {
        let backgroundGradient = CAGradientLayer()
        
        backgroundGradient.colors = [firstColor.cgColor, secondColor.cgColor]
        backgroundGradient.locations = [0, 1]
        backgroundGradient.startPoint = CGPoint(x: 0, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0, y: 1)
        
        return backgroundGradient
    }
}
