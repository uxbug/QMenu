//
//  QMJumpHelper.swift
//  QMenu
//
//  Created by mac on 2022/11/9.
//

import Foundation

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
        
    }
}
