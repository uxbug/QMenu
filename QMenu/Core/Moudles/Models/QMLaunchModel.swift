//
//  QMLaunchModel.swift
//  QMenu
//
//  Created by password 1234 on 9/10/21.
//

import Cocoa
import HandyJSON

enum LaunchMode: Int {
    case editor = 0 // 开发工具
    case terminal = 1   // 终端
}

class QMLaunchModel: QMBaseModel {
    
    var icon: String = ""   // 默认图标
    var desc: String = ""   // 描述
    var bundleId: String = ""   // bundleId
    var mode: LaunchMode = .editor  // 类型
    var iconPath: String = ""   // 自定义图标
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper <<< mode <-- TransformOf<LaunchMode, Int> (fromJSON: { value in
            return LaunchMode.init(rawValue: value ?? 0)
        }, toJSON: { value in
            return value?.rawValue ?? 0
        })
    }
}
