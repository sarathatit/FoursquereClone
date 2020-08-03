//
//  UIColor+Extension.swift
//  Foursquare Clone
//
//  Created by sarath kumar on 31/07/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let universelBlue = UIColor().colorFromHexCode(hexcode: "0000FF")
    static let viewBackground = UIColor().colorFromHexCode(hexcode: "f0e6ef")
    static let pinkColor = UIColor().colorFromHexCode(hexcode: "ef476f")
    static let darkPinkColor = UIColor().colorFromHexCode(hexcode: "f33444")
    
    func colorFromHexCode(hexcode: String) -> UIColor {
        var hexString = hexcode.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return UIColor.black
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255, green: CGFloat((rgb & 0x00FF00) >> 8)/255, blue: CGFloat(rgb & 0x0000FF)/255, alpha: 1.0)
    }
}
