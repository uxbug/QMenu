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
    
    var state: NSControl.StateValue = .on
    var title: String = ""
    var id: Int = 0
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< state <-- TransformOf<NSControl.StateValue, Int> (fromJSON: { value in
            return NSControl.StateValue.init(value ?? NSControl.StateValue.on.rawValue)
        }, toJSON: { value in
            return value == .on ? 1 : 0
        })
    }
}
