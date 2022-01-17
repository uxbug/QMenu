//
//  QMTableView.swift
//  QMenu
//
//  Created by password 1234 on 9/14/21.
//

import Cocoa

protocol QMTableViewDelegate: NSTableViewDelegate {
    func tableView(_ tableView: QMTableView, didClickRightMenuAt row: Int)
}

class QMTableView: NSTableView {

    weak var qm_delegate: QMTableViewDelegate?
    
    override func menu(for event: NSEvent) -> NSMenu? {
        switch event.type {
        case .rightMouseDown:
            let point = convert(event.locationInWindow, from: nil)
            let row = row(at: point)
            let menu = NSMenu.init()
            let replaceIcon = NSMenuItem.init(title: "替换图标", action: #selector(replaceIcon), keyEquivalent: "")
            replaceIcon.tag = row
            menu.addItem(replaceIcon)
            return menu
        default:
            return nil
        }
    }
    
    @objc func replaceIcon(item: NSMenuItem) {
        qm_delegate?.tableView(self, didClickRightMenuAt: item.tag)
    }
}
