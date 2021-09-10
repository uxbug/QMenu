//
//  QMOpenModel.swift
//  QMenu
//
//  Created by password 1234 on 9/10/21.
//

import Cocoa
import HandyJSON

enum OpenMode: Int {
    case editor = 0 // 开发工具
    case terminal = 1   // 终端
}

class QMOpenModel: QMBaseModel {
    
    var icon: String = ""
    var desc: String = ""
    var bundleId: String = ""
    var mode: OpenMode = .editor
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper <<< mode <-- TransformOf<OpenMode, Int> (fromJSON: { value in
            return OpenMode.init(rawValue: value ?? 0)
        }, toJSON: { value in
            return value?.rawValue ?? 0
        })
    }
}
