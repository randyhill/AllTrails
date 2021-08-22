//
//  UIColor+Eats.swift
//  Eats!
//          Some useful UIColor utilities for creating colors from hex strings.
//
//  Created by Randy Hill on 8/21/21.
//

import UIKit

extension UIColor {
    
    /// The six-digit hexadecimal representation of color of the form #RRGGBB.
    ///
    /// - Parameters:
    ///   - hex6: Six-digit hexadecimal value.
    ///   - alpha: The alpha. Default: 1
    
    convenience init(hex6: UInt64, alpha: CGFloat) {
        let divisor: CGFloat = CGFloat(255)
        let red: CGFloat     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green: CGFloat   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue: CGFloat    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// The rgba string representation of color with alpha of the form "#RRGGBB", returns nil if not 6 chars or not parsable..
    /// - Parameter rgba: Hex string
    
    convenience init?(rgba: String, alpha: CGFloat = 1) {
        guard rgba.hasPrefix("#") else {
            Log.error("Missing hash mark in hex color: \(rgba)")
            return nil
        }

        let startIndex: String.Index = rgba.index(rgba.startIndex, offsetBy: 1)
        let hexString: String = String(rgba[startIndex...])
        var hexValue: UInt64 = 0

        guard Scanner(string: hexString).scanHexInt64(&hexValue) else {
            Log.error("Scanner failed to scan hex color: \(rgba)")
            return nil
        }

        switch hexString.count {
        case 6:
            self.init(hex6: hexValue, alpha: alpha)
        default:
            Log.error("We only convert 6 character hash colors at the moment, not: \(rgba)")
            return nil
        }
    }
    
    // Allows us to initialize colors from hex strings.
    convenience init?(hexString: String, alpha: CGFloat) {
        guard let color = UIColor(rgba: hexString, alpha: alpha) else {
            return nil
        }
        self.init(cgColor: color.cgColor)
    }
    
    static var eatsGrayText: UIColor {
        return UIColor(hexString:"#808080", alpha: 1.0)!
    }
    
    static var eatsGrayBorder: UIColor {
        return UIColor(hexString:"#808080", alpha: 0.25)!
    }
    
    static var eatsTableBackground: UIColor {
        return UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    }
}
