//
//  QMSkipController.swift
//  QMenu
//
//  Created by password 1234 on 12/22/21.
//

import Cocoa
import macOSThemeKit

class QMSkipController: QMBaseController {

    @IBOutlet weak var autoView: NSView!
    @IBOutlet weak var autoImageView: NSImageView!
    @IBOutlet weak var autoLabel: NSTextField!
    @IBOutlet weak var lightView: NSView!
    @IBOutlet weak var lightImageView: NSImageView!
    @IBOutlet weak var lightLabel: NSTextField!
    @IBOutlet weak var darkView: NSView!
    @IBOutlet weak var darkImageView: NSImageView!
    @IBOutlet weak var darkLabel: NSTextField!
    
    typealias SkipHandler = (SkipStyle)->()
    var didSelectSkip: SkipHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
}

fileprivate extension QMSkipController {
    func makeUI() {
        autoView.addGestureRecognizer(NSClickGestureRecognizer.init(target: self, action: #selector(onClickSkip(_:))))
        lightView.addGestureRecognizer(NSClickGestureRecognizer.init(target: self, action: #selector(onClickSkip(_:))))
        darkView.addGestureRecognizer(NSClickGestureRecognizer.init(target: self, action: #selector(onClickSkip(_:))))
        
        autoImageView.image = ThemeImage.skipAutoImage
        lightImageView.image = ThemeImage.skipLightImage
        darkImageView.image = ThemeImage.skipDarkImage
        autoLabel.textColor = ThemeColor.skipTextColor
        lightLabel.textColor = ThemeColor.skipTextColor
        darkLabel.textColor = ThemeColor.skipTextColor
        
        autoView.wantsLayer = true
        autoView.layer?.cornerRadius = 5.0
        autoView.layer?.masksToBounds = true
        autoView.backgroundColor = ThemeColor.skipBackgroundColor
        
        lightView.wantsLayer = true
        lightView.layer?.cornerRadius = 5.0
        lightView.layer?.masksToBounds = true
        lightView.backgroundColor = ThemeColor.skipBackgroundColor
        
        darkView.wantsLayer = true
        darkView.layer?.cornerRadius = 15.0
        darkView.layer?.masksToBounds = true
        darkView.backgroundColor = ThemeColor.skipBackgroundColor
        
        updateImageBackgroundColor()
    }
    
    func updateImageBackgroundColor() {
        // 设置选中背景
        switch QMDataManager.shared.currentSkip {
        case .system:
            autoView.backgroundColor = NSColor.init(hex: 0xF5F4F4)
            autoLabel.textColor = NSColor.init(hex: 0x000000)
            autoImageView.image = NSImage.init(named: "skip_auto_light")
            lightView.backgroundColor = ThemeColor.skipBackgroundColor
            darkView.backgroundColor = ThemeColor.skipBackgroundColor
        case .light:
            autoView.backgroundColor = ThemeColor.skipBackgroundColor
            lightView.backgroundColor = NSColor.init(hex: 0xF5F4F4)
            lightLabel.textColor = NSColor.init(hex: 0x000000)
            lightImageView.image = NSImage.init(named: "skip_light_light")
            darkView.backgroundColor = ThemeColor.skipBackgroundColor
        case .dark:
            autoView.backgroundColor = ThemeColor.skipBackgroundColor
            lightView.backgroundColor = ThemeColor.skipBackgroundColor
            darkView.backgroundColor = NSColor.init(hex: 0xF5F4F4)
            darkLabel.textColor = NSColor.init(hex: 0x000000)
            darkImageView.image = NSImage.init(named: "skip_dark_light")
        }
    }
    
    @objc func onClickSkip(_ ges: NSClickGestureRecognizer) {
        let view = ges.view
        if view == autoView {
            didSelectSkip?(.system)
        } else if view == lightView {
            didSelectSkip?(.light)
        } else if view == darkView {
            didSelectSkip?(.dark)
        }
        updateImageBackgroundColor()
    }
}
