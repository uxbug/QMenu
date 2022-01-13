//
//  QMLoger.swift
//  FinderPlugin
//
//  Created by password 1234 on 8/16/21.
//  Copyright © 2021 password 1234. All rights reserved.
//

import Cocoa

/// 日志清理模式
enum QMLogCleanMode: Int {
    case weak = 7
    case month = 30
    case manual = -1
}

struct QMLoger {
    
    /// 所有的日志文件
    static var logs: [String] {
        get {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: logPath()).filter({ $0.hasSuffix("log") }).sorted(by: { $0.compare($1) == .orderedDescending })
            } catch {
                return []
            }
        }
    }
    
    /// 日志存储路径
    /// - Returns: 存储路径
    static func logPath() -> String {
        let path = "/Users/\(QMUtiles.User.userName)" + "/.QMenu/logs"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    /// 添加日志
    /// - Parameter message: 日志信息
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
    
    /// 获取日志内容
    /// - Parameter name: 日志文件名称
    /// - Returns: 日志内容
    static func getLog(with name: String) -> String? {
        let path = logPath() + "/\(name)"
        if FileManager.default.fileExists(atPath: path) {
            let value = try? String.init(contentsOfFile: path, encoding: .utf8)
            return value
        }
        return nil
    }
    
    /// 清理过期日志
    static func cleanOverdueLogs() {
        let cleanLogBlock: (Int)->() = { (day) in
            guard day > 0 else {
                return
            }
            for log in logs {
                let name = log.deletingPathExtension
                guard let date = Date.toDate(with: name, format: "yyyy-MM-dd") else {
                    return
                }
                let calender = Calendar.current
                let components = calender.dateComponents([.day], from: date, to: Date())
                if components.day ?? 0 > day {
                    cleanLog(with: log)
                }
            }
        }
        cleanLogBlock(QMDataManager.shared.logMode.rawValue)
    }
    
    /// 清理日志
    /// - Parameter name: 日志名称
    static func cleanLog(with name: String) {
        let path = logPath() + "/\(name)"
        try? FileManager.default.removeItem(atPath: path)
    }
}
