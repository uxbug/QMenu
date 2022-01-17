//
//  QMBaseModel.swift
//  QMenu
//
//  Created by password 1234 on 9/10/21.
//

import Cocoa
import HandyJSON

class QMBaseModel: NSObject, HandyJSON {
    required override init() {
        
    }
    
    var state: NSControl.StateValue = .on  // 启用状态
    var title: String = ""  // 标题
    var id: Int = 0 // id
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< state <-- TransformOf<NSControl.StateValue, Int> (fromJSON: { value in
            return NSControl.StateValue.init(value ?? NSControl.StateValue.on.rawValue)
        }, toJSON: { value in
            return value?.rawValue ?? NSControl.StateValue.on.rawValue
        })
    }
}
