//
//  QMOpenCellView.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa

protocol QMOpenCellViewDelegate: NSObjectProtocol {
    func openCellView(_ view: QMOpenCellView, didClickBox state: NSControl.StateValue)
}

class QMOpenCellView: QMTableCellView {
    
    @IBOutlet var box: NSButton!
    weak var delegate: QMOpenCellViewDelegate?
    
    @IBAction func onClickBox(_ sender: NSButton) {
        delegate?.openCellView(self, didClickBox: sender.state)
    }
}
