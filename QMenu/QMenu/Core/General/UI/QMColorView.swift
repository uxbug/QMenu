//
//  QMColorView.swift
//  QMenu
//
//  Created by password 1234 on 12/22/21.
//

import Cocoa
import macOSThemeKit

class QMColorView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        ThemeColor.backgroundColor.set()
        NSBezierPath.init(rect: bounds).fill()
    }
    
}
