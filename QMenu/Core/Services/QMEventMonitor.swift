//
//  QMEventMonitor.swift
//  QMenu
//
//  Created by password 1234 on 12/24/21.
//

import Cocoa

class QMEventMonitor: NSObject {
    typealias EvenetHandler = (NSEvent)->()
    
    private var mask: NSEvent.EventTypeMask!
    private var handler: EvenetHandler!
    private var monitor: Any?
    
    init(_ mask: NSEvent.EventTypeMask, _ handler: @escaping EvenetHandler) {
        super.init()
        self.mask = mask
        self.handler = handler
    }
    
    func start() {
        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: self.mask, handler: self.handler)
    }
    
    func stop() {
        if let m = self.monitor {
            NSEvent.removeMonitor(m)
            self.monitor = nil
        }
    }
}
