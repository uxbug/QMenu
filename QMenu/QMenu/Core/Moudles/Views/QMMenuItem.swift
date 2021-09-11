//
//  QMMenuItem.swift
//  QMenu
//
//  Created by password 1234 on 9/2/21.
//

import Cocoa

protocol QMMenuItemDelegate: NSObjectProtocol {
    func menuItem(_ item: QMMenuItem, didSelectAt selected: Bool)
}

class QMMenuItem: NSCollectionViewItem {

    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var textLabel: NSTextField!
    weak var delegate: QMMenuItemDelegate?
    var data: (String, String) = ("", "") {
        didSet {
            textLabel.stringValue = data.0
            iconView.image = NSImage.init(named: data.1.appending("_normal"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
    }
    
    override var isSelected: Bool {
        didSet {
            textLabel.textColor = isSelected ? NSColor.init(hex: 0x38A3A5) : NSColor.init(hex: 0x112031)
            view.layer?.backgroundColor = isSelected ? NSColor.init(hex: 0xF5F4F4).cgColor : NSColor.clear.cgColor
            iconView.image = NSImage.init(named: data.1.appending(isSelected ? "_select" : "_normal"))
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.menuItem(self, didSelectAt: isSelected)
    }
}
