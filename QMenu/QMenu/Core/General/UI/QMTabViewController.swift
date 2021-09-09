//
//  QMTabViewController.swift
//  QMenu
//
//  Created by password 1234 on 8/31/21.
//

import Cocoa

class QMTabViewController: QMBaseController {

    var selectedIndex: Int = 0 {
        didSet {
            let child = children.reversed()[selectedIndex]
            view.addSubview(child.view)
            view.subviews.forEach { v in
                if children.map({ $0.view }).contains(v), v != child.view {
                    v.removeFromSuperview()
                } else {
                    child.view.frame = view.bounds
                    child.updateViewConstraints()
                }
            }
        }
    }
    
    var firstLoad: Bool = false
    
    override func loadView() {
        view = NSView.init()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLoad = true
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        if firstLoad {
            selectedIndex = 0
            firstLoad = false
        }
    }
    
    func addChilds(_ childs: [NSViewController]) {
        for child in childs.reversed() {
            addChild(child)
        }
    }
    
}
