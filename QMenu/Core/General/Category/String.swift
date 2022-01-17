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
}
