//
//  QMFeatureModel.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa
import HandyJSON

class QMFeatureModel: NSObject, HandyJSON {
    
    enum FeatureType: Int {
        case newFile = 0    // 文件模板
        case open = 1   // 打开方式
        case move = 2  // 移动至常用目录
        case copy = 3  // 拷贝至常用目录
        case unpack = 4  // 解包Assets.car
        case copyPath = 5  // 拷贝路径
        case delete = 6  // 直接删除
    }
    
    enum Mode: Int {
        case editor = 0 // 开发工具
        case terminal = 1   // 终端
    }
    
    var state: NSControl.StateValue = .on
    var title: String = ""
    var icon: String = ""
//    var image: NSImage?
    var desc: String = ""
    var id: Int = 0
    var type: FeatureType = .newFile
    var path: String = ""
    var bundleId: String = ""
    var mode: Mode = .editor
    
    required override init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< type <-- TransformOf<FeatureType, Int> (fromJSON: { value in
            return FeatureType.init(rawValue: value ?? 3) ?? .newFile
        }, toJSON: { value in
            return value?.rawValue ?? 3
        })
        mapper <<< state <-- TransformOf<NSControl.StateValue, Int> (fromJSON: { value in
            return NSControl.StateValue.init(value ?? NSControl.StateValue.on.rawValue)
        }, toJSON: { value in
            return value == .on ? 1 : 0
        })
        mapper <<< mode <-- TransformOf<Mode, Int> (fromJSON: { value in
            return Mode.init(rawValue: value ?? 0)
        }, toJSON: { value in
            return value?.rawValue ?? 0
        })
    }
}
