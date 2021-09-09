//
//  QMTableRowView.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa

class QMTableRowView: NSTableRowView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
    }
    
    override func drawSelection(in dirtyRect: NSRect) {
        if selectionHighlightStyle != .none {
            let rect = bounds.insetBy(dx: 0, dy: 0)
            NSColor.init(hex: 0xF5F4F4).setFill()
            let path = NSBezierPath.init(roundedRect: rect, xRadius: 0, yRadius: 0)
            path.fill()
        }
    }
}
