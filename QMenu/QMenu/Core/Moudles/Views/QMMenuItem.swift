//
//  QMMenuItem.swift
//  QMenu
//
//  Created by password 1234 on 9/2/21.
//

import Cocoa
import macOSThemeKit

enum TabStyle {
    case feature
    case launch
    case directory
    case newFile
    case setting
    case desc
    case about
}

protocol QMMenuItemDelegate: NSObjectProtocol {
    func menuItem(_ item: QMMenuItem, didSelectAt selected: Bool)
}

class QMMenuItem: NSCollectionViewItem {

    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var textLabel: NSTextField!
    weak var delegate: QMMenuItemDelegate?
    var data: (String, TabStyle) = ("", .feature) {
        didSet {
            textLabel.stringValue = data.0
            switch data.1 {
            case .feature:
                iconView.image = ThemeImage.menuFeatureNormalImage
            case .launch:
                iconView.image = ThemeImage.menuLaunchNormalImage
            case .directory:
                iconView.image = ThemeImage.menuDirectoryNormalImage
            case .newFile:
                iconView.image = ThemeImage.menuNewFileNormalImage
            case .setting:
                iconView.image = ThemeImage.menuSettingNormalImage
            case .desc:
                iconView.image = ThemeImage.menuDescNormalImage
            case .about:
                iconView.image = ThemeImage.menuAboutNormalImage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
    }
    
    override var isSelected: Bool {
        didSet {
            textLabel.textColor = isSelected ? NSColor.init(hex: 0x38A3A5) : ThemeColor.menuNormalTextColor
            view.layer?.backgroundColor = isSelected ? NSColor.init(hex: 0xF5F4F4).cgColor : NSColor.clear.cgColor
            var normalImg: NSImage?, selectedImg: NSImage?
            switch data.1 {
            case .feature:
                normalImg = ThemeImage.menuFeatureNormalImage
                selectedImg = NSImage.init(named: "tab_feature_select")
            case .launch:
                normalImg = ThemeImage.menuLaunchNormalImage
                selectedImg = NSImage.init(named: "tab_launch_select")
            case .directory:
                normalImg = ThemeImage.menuDirectoryNormalImage
                selectedImg = NSImage.init(named: "tab_directory_select")
            case .newFile:
                normalImg = ThemeImage.menuNewFileNormalImage
                selectedImg = NSImage.init(named: "tab_file_select")
            case .setting:
                normalImg = ThemeImage.menuSettingNormalImage
                selectedImg = NSImage.init(named: "tab_setting_select")
            case .desc:
                normalImg = ThemeImage.menuDescNormalImage
                selectedImg = NSImage.init(named: "tab_desc_select")
            case .about:
                normalImg = ThemeImage.menuAboutNormalImage
                selectedImg = NSImage.init(named: "tab_about_select")
            }
            iconView.image = isSelected ? selectedImg : normalImg
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.menuItem(self, didSelectAt: isSelected)
    }
}
