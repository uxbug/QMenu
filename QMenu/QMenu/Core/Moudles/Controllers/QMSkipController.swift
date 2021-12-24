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
        
        autoImageView.wantsLayer = true
        autoImageView.layer?.cornerRadius = 15.0
        autoImageView.layer?.masksToBounds = true
        autoImageView.backgroundColor = ThemeColor.skipBackgroundColor
        
        lightImageView.wantsLayer = true
        lightImageView.layer?.cornerRadius = 15.0
        lightImageView.layer?.masksToBounds = true
        lightImageView.backgroundColor = ThemeColor.skipBackgroundColor
        
        darkImageView.wantsLayer = true
        darkImageView.layer?.cornerRadius = 15.0
        darkImageView.layer?.masksToBounds = true
        darkImageView.backgroundColor = ThemeColor.skipBackgroundColor
        
        updateImageBackgroundColor()
    }
    
    func updateImageBackgroundColor() {
        // 设置选中背景
        switch QMDataManager.shared.currentSkip {
        case .system:
            autoImageView.backgroundColor = NSColor.init(hex: 0x38A3A5)
            lightImageView.backgroundColor = ThemeColor.skipBackgroundColor
            darkImageView.backgroundColor = ThemeColor.skipBackgroundColor
        case .light:
            autoImageView.backgroundColor = ThemeColor.skipBackgroundColor
            lightImageView.backgroundColor = NSColor.init(hex: 0x38A3A5)
            darkImageView.backgroundColor = ThemeColor.skipBackgroundColor
        case .dark:
            autoImageView.backgroundColor = ThemeColor.skipBackgroundColor
            lightImageView.backgroundColor = ThemeColor.skipBackgroundColor
            darkImageView.backgroundColor = NSColor.init(hex: 0x38A3A5)
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
