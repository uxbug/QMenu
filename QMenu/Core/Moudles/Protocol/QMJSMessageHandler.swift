//
//  QMJSMessageHandler.swift
//  QMenu
//
//  Created by mac on 2022/11/9.
//

import Foundation
import WebKit

class QMJSMessageHandler: NSObject, WKScriptMessageHandler {
    
    struct Event {
        static let currentTheme = "getCurrentTheme"
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
    }
}
