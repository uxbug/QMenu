//
//  QMLoger.swift
//  FinderPlugin
//
//  Created by password 1234 on 8/16/21.
//  Copyright © 2021 password 1234. All rights reserved.
//

import Cocoa

enum QMLogMode: Int {
    case weak = 0
    case month = 1
    case manual = 2
}

struct QMLoger {
    static func logPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].components(separatedBy: "/")
        var path: String = ""
        if paths.count >= 3 {
            path = paths[0...2].joined(separator: "/") + "/.QMenu/logs"
        }
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    static func addLog(_ message: String) {
        let date = Date.init().toString(with: "yyyy-MM-dd")
        let time = Date.init().toString(with: "HH:mm:ss")
        let fileName = "\(date).log"
        let logFilePath = logPath() + "/" + fileName
        var result: String = ""
        if FileManager.default.fileExists(atPath: logFilePath) {
            if let content = try? String.init(contentsOfFile: logFilePath, encoding: .utf8) {
                result = content + "\n" + time + " " + message
            } else {
                result = time + " " + message
            }
            guard let _ = try? FileManager.default.removeItem(atPath: logFilePath) else {
                return
            }
        } else {
            result = time + " " + message
        }
        FileManager.default.createFile(atPath: logFilePath, contents: result.data(using: .utf8), attributes: nil)
    }
}
