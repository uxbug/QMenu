//
//  QMUtiles.swift
//  QMenu
//
//  Created by password 1234 on 12/24/21.
//

import Foundation

struct QMUtiles {
    struct User {
        /// 用户电脑名
        static var userName: String {
            let home = NSHomeDirectory()
            let paths = (home as NSString).pathComponents
            guard paths.count > 3 else {
                return ""
            }
            if paths[0] == "/" {
                return paths[2]
            }
            return paths[1]
        }
    }
    
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
        
        static var mainAppBundleId: String {
            return "com.liyb.QMenu"
        }
        
        static var targetAppBundleId: String {
            return "com.liyb.QMenu.QMenuTarget"
        }
    }
}
