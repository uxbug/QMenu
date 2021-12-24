//
//  QMTextCellView.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa
import macOSThemeKit

protocol QMTextCellViewDelegate: NSObjectProtocol {
    func textCellView(_ cellView: QMTextCellView, didEndEditingAt text:String)
}

class QMTextCellView: QMTableCellView {

    @IBOutlet var textLabel: NSTextField!
    weak var delegate: QMTextCellViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.font = NSFont.systemFont(ofSize: 12)
        textLabel.delegate = self
    }
    
    override var backgroundStyle: NSView.BackgroundStyle {
        didSet {
            if backgroundStyle == .emphasized {
                textLabel.textColor = NSColor.init(hex: 0x38A3A5)
            } else {
                textLabel.textColor = ThemeColor.menuNormalTextColor
            }
        }
    }
}

extension QMTextCellView: NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        delegate?.textCellView(self, didEndEditingAt: textLabel.stringValue)
    }
}
