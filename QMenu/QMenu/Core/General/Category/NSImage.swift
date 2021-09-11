//
//  NSImage.swift
//  QMenu
//
//  Created by password 1234 on 9/11/21.
//

import Cocoa

extension NSImage {
    func resize(for size: CGSize) -> NSImage {
        let rect = NSRect.init(x: 0, y: 0, width: size.width, height: size.height)
        let sourceImage = bestRepresentation(for: rect, context: nil, hints: nil)
        let targetImage = NSImage.init(size: size)
        targetImage.lockFocus()
        sourceImage?.draw(in: rect)
        targetImage.unlockFocus()
        return targetImage
    }
}
