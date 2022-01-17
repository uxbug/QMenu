//
//  QMLogItem.swift
//  QMenu
//
//  Created by password 1234 on 9/6/21.
//

import Cocoa
import macOSThemeKit

protocol QMLogItemDelegate: NSObjectProtocol {
    func logItem(_ item: QMLogItem, didSelectAt selected: Bool)
}

class QMLogItem: NSCollectionViewItem {

    @IBOutlet weak var textLabel: NSTextField!
    
    weak var delegate: QMLogItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
    }
    
    override var isSelected: Bool {
        didSet {
            textLabel.textColor = isSelected ? NSColor.init(hex: 0x38A3A5) : ThemeColor.menuNormalTextColor
            view.layer?.backgroundColor = isSelected ? NSColor.init(hex: 0xF5F4F4).cgColor : NSColor.clear.cgColor
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.logItem(self, didSelectAt: isSelected)
    }
}
