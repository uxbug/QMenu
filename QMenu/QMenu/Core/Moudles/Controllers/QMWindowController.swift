//
//  QMWindowController.swift
//  QMenu
//
//  Created by password 1234 on 12/22/21.
//

import Cocoa
import macOSThemeKit

class QMWindowController: NSWindowController {

    @IBOutlet weak var skipItem: NSToolbarItem!
    @IBOutlet weak var toolBar: NSToolbar!
    
    fileprivate lazy var skipView: NSImageView = {
        let view = NSImageView.init(image: NSImage.init(named: "skip_auto_light")!)
        view.addGestureRecognizer(NSClickGestureRecognizer.init(target: self, action: #selector(onClickSkip(_:))))
        return view
    }()
    lazy var skipController: QMSkipController = {
        let vc = QMSkipController.init()
        return vc
    }()
    
    fileprivate lazy var popover: NSPopover = {
        let popover = NSPopover.init()
        popover.contentViewController = skipController
        return popover
    }()
    
    fileprivate var monitor: QMEventMonitor!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        switch QMDataManager.shared.currentSkip {
        case .system:
            skipView.image = ThemeImage.skipAutoImage
            self.skipItem.label = "自动"
        case .light:
            skipView.image = ThemeImage.skipLightImage
            self.skipItem.label = "日模"
        case .dark:
            skipView.image = ThemeImage.skipDarkImage
            self.skipItem.label = "夜模"
        }
        skipItem.view = skipView
        skipItem.minSize = skipView.frame.size
        skipItem.maxSize = skipView.frame.size
        
        skipController.didSelectSkip = { [weak self] skip in
            switch skip {
            case .system:
                ThemeManager.systemTheme.apply()
                self?.skipView.image = ThemeImage.skipAutoImage
                self?.skipItem.label = "自动"
            case .light:
                ThemeManager.lightTheme.apply()
                self?.skipView.image = ThemeImage.skipLightImage
                self?.skipItem.label = "日模"
            case .dark:
                ThemeManager.darkTheme.apply()
                self?.skipView.image = ThemeImage.skipDarkImage
                self?.skipItem.label = "夜模"
            }
            QMDataManager.shared.currentSkip = skip
            self?.popover.close()
            self?.monitor.stop()
        }
        
        monitor = QMEventMonitor.init([.leftMouseDown, .rightMouseDown], { [weak self] event in
            guard let ss = self else {
                return
            }
            if ss.popover.isShown {
                ss.popover.performClose(event)
            }
        })
    }

    @IBAction func onClickSkip(_ sender: Any) {
        if popover.isShown {
            popover.close()
            monitor.stop()
        } else {
            if let item = sender as? NSToolbarItem, let view = item.view {
                popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
            } else if let ges = sender as? NSClickGestureRecognizer, let view = ges.view {
                var bounds = view.bounds
                bounds.size = CGSize.init(width: bounds.width, height: bounds.height + 20)
                popover.show(relativeTo: bounds, of: view, preferredEdge: .minY)
            }
            monitor.start()
        }
    }
}
