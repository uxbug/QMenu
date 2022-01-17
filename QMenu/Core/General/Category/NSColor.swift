//
//  NSColor.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa

protocol Hex {
    var string: String? { get }
    var code: UInt? { get }
}

extension String: Hex {
    var string: String? { return self }
    var code: UInt? { return nil }
}

extension UInt: Hex {
    var string: String? { return nil }
    var code: UInt? { return self }
}

extension Int: Hex {
    var string: String? { return nil }
    var code: UInt? { return UInt(self) }
}

extension NSColor {
    
    convenience init(hex: Hex) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1
        if let hexStr = hex.string {
            var hexStr: String = hexStr
            if hexStr.hasPrefix("#") {
                let index = hexStr.index(hexStr.startIndex, offsetBy: 1)
                hexStr = String(hexStr[index...])
            }
            if hexStr.hasPrefix("0x") {
                let index = hexStr.index(hexStr.startIndex, offsetBy: 2)
                hexStr = String(hexStr[index...])
            }
            let scanner = Scanner(string: hexStr)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hexStr.count) {
                case 3:
                    red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    alpha = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                    break
                }
            }
        } else if let hexCode = hex.code {
            var r: UInt = 0, g: UInt = 0, b: UInt = 0;
            var a: UInt = 0xFF
            var rgb = hexCode
            if (hexCode & 0xFFFF0000) == 0 {
                a = 0xF
                if hexCode & 0xF000 > 0 {
                    a = hexCode & 0xF
                    rgb = hexCode >> 4
                }
                r = (rgb & 0xF00) >> 8
                r = (r << 4) | r

                g = (rgb & 0xF0) >> 4
                g = (g << 4) | g

                b = rgb & 0xF
                b = (b << 4) | b
                
                a = (a << 4) | a
            } else {
                if hexCode & 0xFF000000 > 0 {
                    a = hexCode & 0xFF
                    rgb = hexCode >> 8
                }
                r = (rgb & 0xFF0000) >> 16
                g = (rgb & 0xFF00) >> 8
                b = rgb & 0xFF
            }
            red = CGFloat(r) / 255.0
            green = CGFloat(g) / 255.0
            blue = CGFloat(b) / 255.0
            alpha = CGFloat(a) / 255.0
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
