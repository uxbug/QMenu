//
//  String.swift
//  QMenu
//
//  Created by password 1234 on 9/8/21.
//

import Foundation

extension String {
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    var deletingLastPathComponent: String {
        return self.replacingOccurrences(of: lastPathComponent, with: "")
    }
    
    var expandingTildeInPath: String {
        return (self as NSString).expandingTildeInPath
    }
    
    var base64EncodedString: String? {
        let data = data(using: .utf8)
        return data?.base64EncodedString()
    }
    
    var base64DecodingString: String? {
        guard let data = data(using: .utf8), let baseData = Data(base64Encoded: data) else { return nil }
        return String(data: baseData, encoding: .utf8)
    }
    
    static var userHome: String {
        var homePath: String = ""
        if #available(macOS 10.12, *) {
            let url = FileManager.default.homeDirectoryForCurrentUser
            let path = url.path
            homePath = path
        } else {
            homePath = NSHomeDirectory()
        }
        let sepArr = homePath.components(separatedBy: "/")
        if sepArr.count <= 2 {
            return "/Users/\(NSUserName())"
        } else {
            return "/Users/\(sepArr[2])"
        }
    }
    
    /// 处理空格
    /// `count`: number of escape characters.
    func nameSpaceEscaped(_ count: Int = 1) -> String {
        let escapeChar = String(repeating: "\\", count: count)
        let escapeSpace = escapeChar + " "
        let replaced = self.replacingOccurrences(of: " ", with: escapeSpace)
        return replaced
    }
    
    /// 处理特殊字符
    /// `count`: number of escape characters.
    func specialCharEscaped(_ count: Int = 1) -> String {
        let escapeChar = String(repeating: "\\", count: count)
        var result = ""
        let set: [Character] = [" ", "(", ")", "&", "|", ";",
                                "\"", "'", "<", ">", "`"]
        for char in self {
            if set.contains(char) {
                result += escapeChar
            }
            result.append(char)
        }
        return result
    }
    
    // FIXME: if path contains "\" or """, application will crash.
    // Special symbols have been tested, except for backslashes and double quotes.
    func terminalPathEscaped() -> String {
        var result = ""
        let set = CharacterSet.alphanumerics
        for char in self.unicodeScalars {
            if set.contains(char) || char == "/" {
                result.unicodeScalars.append(char)
            } else {
                result += "\\\\"
                result.unicodeScalars.append(char)
            }
        }
        return result
    }
    
    func substring(to index: Int) -> String {
        return (self as NSString).substring(to: index)
    }
    
    func substring(from index: Int) -> String {
        return (self as NSString).substring(from: index)
    }
    
    func substring(with range: NSRange) -> String {
        return (self as NSString).substring(with: range)
    }
    
    func range(of string: String) -> NSRange {
        return (self as NSString).range(of: string)
    }
}
