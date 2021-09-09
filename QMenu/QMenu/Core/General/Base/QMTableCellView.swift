//
//  QMTableCellView.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa

class QMTableCellView: NSTableCellView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
    }
    
}
