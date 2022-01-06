//
//  RMAppDelegate.swift
//  QMenu
//
//  Created by password 1234 on 8/19/21.
//

import Cocoa
import macOSThemeKit

@main
class QMAppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupTheme()
        QMDataManager.shared.updateDefaultConfig()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // 点击dock再次启动
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        let isVisible = sender.mainWindow?.isVisible
        if isVisible == nil || isVisible == false {
            sender.windows.forEach { window in
                window.makeKeyAndOrderFront(self)
            }
        }
        return true
    }
    
}
 
fileprivate extension QMAppDelegate {
    func setupTheme() {
        switch QMDataManager.shared.currentSkip {
        case .system:
            ThemeManager.systemTheme.apply()
        case .light:
            ThemeManager.lightTheme.apply()
        case .dark:
            ThemeManager.darkTheme.apply()
        }
    }
    
    @IBAction func onClickAbout(_ sender: Any) {
        let isVisible = NSApp.mainWindow?.isVisible
        if isVisible == nil || isVisible == false {
            NSApp.windows.forEach { window in
                window.makeKeyAndOrderFront(self)
            }
        }
        let rootController = NSApp.mainWindow?.contentViewController as? QMRootController
        rootController?.selectIndex = 5
    }
    
    @IBAction func onClickDesc(_ sender: Any) {
        let isVisible = NSApp.mainWindow?.isVisible
        if isVisible == nil || isVisible == false {
            NSApp.windows.forEach { window in
                window.makeKeyAndOrderFront(self)
            }
        }
        let rootController = NSApp.mainWindow?.contentViewController as? QMRootController
        rootController?.selectIndex = 4
    }
}
