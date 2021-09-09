//
//  NSView.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa

extension NSView {
    var backgroundColor: NSColor? {
        get {
            guard let cgColor = layer?.backgroundColor else {
                return .clear
            }
            return NSColor.init(cgColor: cgColor)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
}
