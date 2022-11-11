//
//  QMUtiles.swift
//  QMenu
//
//  Created by password 1234 on 12/24/21.
//

import Foundation
import AppKit

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
        
        static var isDarkMode: Bool {
            let apperance = NSApp.effectiveAppearance;
            if #available(macOS 10.14, *) {
                if apperance.bestMatch(from: [NSAppearance.Name.darkAqua, NSAppearance.Name.aqua]) == NSAppearance.Name.darkAqua {
                    return true  //'深色'模式
                }
            }
            return false  //'浅色'模式
        }
    }
    
    struct Notification {
        static let skipChange = NSNotification.Name.init("skipChange")
    }
    
    struct Authoration {
        // 完全访问磁盘权限
        enum FullDiskStatus {
            case notDetermined
            case denied
            case authorized
        }
        
        static var fullDiskStatus: FullDiskStatus {
            if #available(macOS 10.14, *) {
                //用户目录可能获取不准确，所以通过两种方法获取用户路径并进行验证
                let userHome = String.userHome
                let safariHomePath = userHome.appending("/Library/Safari")
                guard let contents = try? FileManager.default.contentsOfDirectory(atPath: safariHomePath) else {
                    return .notDetermined
                }
                if contents.count > 0 {
                    return .authorized
                } else {
                    var path = userHome.appending("/Library/Safari/LastSession.plist")
                    var fileExists = FileManager.default.fileExists(atPath: path)
                    if !fileExists {
                        path = userHome.appending("/Library/Safari/Bookmarks.plist")
                        fileExists = FileManager.default.fileExists(atPath: path)
                    }
                    let data = try? Data.init(contentsOf: URL(fileURLWithPath: path))
                    if data == nil, fileExists {
                        return .denied
                    } else if fileExists {
                        return .authorized
                    } else {
                        return .notDetermined
                    }
                }
            } else {
                return .authorized
            }
        }
        
        static func openFullDiskAuthPrefreence() {
            guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }
}
