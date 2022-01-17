//
//  Date.swift
//  NetEaseMusic
//
//  Created by password 1234 on 7/1/21.
//  Copyright © 2021 liyb. All rights reserved.
//

import Foundation

extension Date {
    static var timestampStr: String {
        return "\(timestamp)"
    }
    
    static var timestamp: Int {
        let timeInterval: TimeInterval = Date.init().timeIntervalSince1970
        return Int(CLongLong(round(timeInterval*1000)))
    }
    
    static func toDate(with string: String, format: String) -> Date? {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    func toString(with format: String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// 秒转时分秒
    /// - Parameters:
    ///   - second: 秒
    ///   - symbol: 间隔符
    /// - Returns: 时分秒
    static func toHMS(_ second: Int, symbol: String = ":") -> String {
        let hour = second / 3600
        let minute = (second / 60) % 60
        let sec = second % 60
        if hour == 0 {
            return String.init(format: "%02zi%@%02zi", minute, symbol, sec)
        }
        return String.init(format: "%02zi%@%02zi%@%02zi", minute, symbol, sec, symbol, sec)
    }
    
    /// 年
    static var year: String {
        get {
            let date = Date.init()
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: date)
        }
    }
}
