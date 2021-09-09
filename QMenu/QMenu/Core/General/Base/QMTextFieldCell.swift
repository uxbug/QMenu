//
//  QMTextFieldCell.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa

class QMTextFieldCell: NSTextFieldCell {
    var mIsEditingOrSelecting:Bool = false
    override func drawingRect(forBounds theRect: NSRect) -> NSRect {
        var newRect:NSRect = super.drawingRect(forBounds: theRect)
        if !mIsEditingOrSelecting {
            let textSize:NSSize = self.cellSize(forBounds: theRect)
            let heightDelta:CGFloat = newRect.size.height - textSize.height
            if heightDelta > 0 {
                newRect.size.height -= heightDelta
                newRect.origin.y += heightDelta/2
            }
        }
        return newRect
    }
        
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
            let arect = self.drawingRect(forBounds: rect)
            mIsEditingOrSelecting = true;
            super.select(withFrame: arect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
            mIsEditingOrSelecting = false;
        }
        
        override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
            let aRect = self.drawingRect(forBounds: rect)
            mIsEditingOrSelecting = true;
            super.edit(withFrame: aRect, in: controlView, editor: textObj, delegate: delegate, event: event)
            mIsEditingOrSelecting = false
        }
}
