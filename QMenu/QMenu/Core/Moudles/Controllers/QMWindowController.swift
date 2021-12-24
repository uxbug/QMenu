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
        case .light:
            skipView.image = ThemeImage.skipLightImage
        case .dark:
            skipView.image = ThemeImage.skipDarkImage
        }
        skipItem.view = skipView
        skipItem.minSize = skipView.frame.size
        skipItem.maxSize = skipView.frame.size
        
        skipController.didSelectSkip = { [weak self] skip in
            switch skip {
            case .system:
                ThemeManager.systemTheme.apply()
                self?.skipView.image = ThemeImage.skipAutoImage
            case .light:
                ThemeManager.lightTheme.apply()
                self?.skipView.image = ThemeImage.skipLightImage
            case .dark:
                ThemeManager.darkTheme.apply()
                self?.skipView.image = ThemeImage.skipDarkImage
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
