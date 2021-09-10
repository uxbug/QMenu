//
//  QMOpenModel.swift
//  QMenu
//
//  Created by password 1234 on 9/10/21.
//

import Cocoa
import HandyJSON

class QMOpenModel: QMBaseModel {
    enum Mode: Int {
        case editor = 0 // 开发工具
        case terminal = 1   // 终端
    }
    
    var icon: String = ""
    var desc: String = ""
    var bundleId: String = ""
    var mode: Mode = .terminal
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper <<< mode <-- TransformOf<Mode, Int> (fromJSON: { value in
            return Mode.init(rawValue: value ?? 0)
        }, toJSON: { value in
            return value?.rawValue ?? 0
        })
    }
}
