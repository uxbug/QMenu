//
//  QMUtiles.swift
//  QMenu
//
//  Created by password 1234 on 12/24/21.
//

import Foundation

struct QMUtiles {
    struct App {
        static var info: [String: Any]? {
            return Bundle.main.infoDictionary
        }
        
        static var name: String {
            return (info?["CFBundleDisplayName"] as? String) ?? "右键菜单"
        }
        
        static var version: String {
            return (info?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
        }
        
        static var bundleId: String {
            return (info?["CFBundleIdentifier"] as? String) ?? "com.liyb.QMenu"
        }
    }
}
