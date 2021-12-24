//
//  ThemeImage.swift
//  QMenu
//
//  Created by password 1234 on 12/22/21.
//

import macOSThemeKit
import AppKit

extension ThemeImage {
    static var menuFeatureNormalImage: ThemeImage {
        return ThemeImage.image(with: #function)
    }
    
    static var menuLaunchNormalImage: ThemeImage {
        return ThemeImage.image(with: #function)
    }
    
    static var menuDirectoryNormalImage: ThemeImage {
        return ThemeImage.image(with: #function)
    }
    
    static var menuNewFileNormalImage: ThemeImage {
        return ThemeImage.image(with: #function)
    }
    
    static var menuDescNormalImage: ThemeImage {
        return ThemeImage.image(with: #function)
    }
    
    static var menuAboutNormalImage: ThemeImage {
        return ThemeImage.image(with: #function)
    }
    
    static var skipAutoImage: ThemeImage {
        return ThemeImage.image(with: #function)
    }
    
    static var skipLightImage: ThemeImage {
        return ThemeImage.image(with: #function)
    }
    
    static var skipDarkImage: ThemeImage {
        return ThemeImage.image(with: #function)
    }
}

extension LightTheme {
    @objc var menuFeatureNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_feature_normal"))
    }
    
    @objc var menuLaunchNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_launch_normal"))
    }
    
    @objc var menuDirectoryNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_directory_normal"))
    }
    
    @objc var menuNewFileNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_file_normal"))
    }
    
    @objc var menuDescNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_desc_normal"))
    }
    
    @objc var menuAboutNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_about_normal"))
    }
    
    @objc var skipAutoImage: NSImage? {
        return NSImage.init(named: .init("skip_auto_light"))
    }
    
    @objc var skipLightImage: NSImage? {
        return NSImage.init(named: .init("skip_light_light"))
    }
    
    @objc var skipDarkImage: NSImage? {
        return NSImage.init(named: .init("skip_dark_light"))
    }
}

extension DarkTheme {
    @objc var menuFeatureNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_feature_normal_dark"))
    }
    
    @objc var menuLaunchNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_launch_normal_dark"))
    }
    
    @objc var menuDirectoryNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_directory_normal_dark"))
    }
    
    @objc var menuNewFileNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_file_normal_dark"))
    }
    
    @objc var menuDescNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_desc_normal_dark"))
    }
    
    @objc var menuAboutNormalImage: NSImage? {
        return NSImage.init(named: .init("tab_about_normal_dark"))
    }
    
    @objc var skipAutoImage: NSImage? {
        return NSImage.init(named: .init("skip_auto_dark"))
    }
    
    @objc var skipLightImage: NSImage? {
        return NSImage.init(named: .init("skip_light_dark"))
    }
    
    @objc var skipDarkImage: NSImage? {
        return NSImage.init(named: .init("skip_dark_dark"))
    }
}
