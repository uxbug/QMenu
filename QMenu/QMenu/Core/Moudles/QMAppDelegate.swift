//
//  RMAppDelegate.swift
//  QMenu
//
//  Created by password 1234 on 8/19/21.
//

import Cocoa
import FinderSync

@main
class QMAppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // 点击dock再次启动
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            sender.windows.forEach { window in
                window.makeKeyAndOrderFront(self)
            }
        }
        return true
    }
}

