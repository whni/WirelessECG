//
//  UIColorExtension.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-17.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit

// Define some color generators
public extension UIColor {

    // Convert hex color to UIColor
    class func UIColorFromHex(hex: Int) -> UIColor {
        var red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        var green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        var blue = CGFloat((hex & 0xFF)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    // Lighten color
    class func lightenUIColor(color: UIColor) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b / 0.6, alpha: a)
    }
    
    // Darken color
    class func darkenUIColor(color: UIColor) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * 0.6, alpha: a)
    }
    
}

// Self-defined colors
struct UIColorPlatte {
    
    static let red600 = UIColor.UIColorFromHex(0xEA404E) //E53935
    static let red500 = UIColor.UIColorFromHex(0xF44336)
    static let redecg = UIColor.UIColorFromHex(0xFFD7D6)
    static let pink200 = UIColor.UIColorFromHex(0xFCE4EC)
    
}