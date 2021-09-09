//
//  QMTextCellView.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa

class QMTextCellView: QMTableCellView {

    @IBOutlet var textLabel: NSTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.font = NSFont.systemFont(ofSize: 12)
        textLabel.maximumNumberOfLines = 0
        textLabel.usesSingleLineMode = false
        (textLabel.cell as? NSTextFieldCell)?.wraps = true
    }
    
    override var backgroundStyle: NSView.BackgroundStyle {
        didSet {
            if backgroundStyle == .emphasized {
                textLabel.textColor = .init(hex: 0x38A3A5)
            } else {
                textLabel.textColor = .init(hex: 0x112031)
            }
        }
    }
}
