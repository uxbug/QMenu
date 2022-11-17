//
//  QMJumpHelper.swift
//  QMenu
//
//  Created by mac on 2022/11/9.
//

import Foundation
import AppKit

struct QMJumpHelper {
    
    static var scheme: String?
    static var host: String?
    static var params: [String: Any]?
    
    static func parser(_ url: URL) {
        let path = url.absoluteString
        scheme = url.scheme
        host = url.host
        let range = path.range(of: "?param=")
        let loc = range.location + range.length
        let len = path.count - loc
        let paramStr = path.substring(with: NSMakeRange(loc, len)).base64DecodingString
        guard let data = paramStr?.data(using: .utf8) else { return }
        params = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        dealResult()
    }
}

private extension QMJumpHelper {
    static func dealResult() {
        guard scheme == "qmenu" else { return }
        guard let openValue = params?["open"] as? Int else { return }
//        let param = params?["param"] as? [String: Any]
        let open = Open.`init`(rawValue: openValue)
        
        let window: NSWindow? = NSApp.windows.last
        let root: QMRootController? = window?.contentViewController as? QMRootController
        switch open {
        case .file:
            root?.selectIndex = 3
        case .directory:
            root?.selectIndex = 2
        case .auth(let value):
            root?.selectIndex = 4
        }
        
    }
}
