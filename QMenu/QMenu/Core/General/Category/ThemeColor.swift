//
//  QMThemeKit.swift
//  QMenu
//
//  Created by password 1234 on 12/21/21.
//

import macOSThemeKit
import AppKit

extension ThemeColor {
    static var menuNormalTextColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var backgroundColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var skipTextColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var skipBackgroundColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var skipSelectBackgroundColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
}

extension LightTheme {
    @objc var menuNormalTextColor: NSColor {
        return NSColor.init(hex: 0x112031)
    }
    
    @objc var backgroundColor: NSColor {
        return NSColor.init(hex: 0xffffff)
    }
    
    @objc var skipTextColor: NSColor {
        return NSColor.init(hex: 0x000000)
    }
    
    @objc var skipBackgroundColor: NSColor {
        return NSColor.clear
    }
    
    @objc var skipSelectBackgroundColor: NSColor {
        return NSColor.init(hex: 0xF5F4F4)
    }
}

extension DarkTheme {
    @objc var menuNormalTextColor: NSColor {
        return NSColor.init(hex: 0xffffff)
    }
    
    @objc var backgroundColor: NSColor {
        return NSColor.init(hex: 0x282928)
    }
    
    @objc var skipTextColor: NSColor {
        return NSColor.init(hex: 0xffffff)
    }
    
    @objc var skipBackgroundColor: NSColor {
        return NSColor.clear
    }
    
    @objc var skipSelectBackgroundColor: NSColor {
        return NSColor.init(hex: 0xF3F1F5)
    }
}
