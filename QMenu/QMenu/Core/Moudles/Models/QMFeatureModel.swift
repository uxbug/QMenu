//
//  QMFeatureModel.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa
import HandyJSON

class QMFeatureModel: QMBaseModel {
    
    enum FeatureType: Int {
        case newFile = 0    // 文件模板
        case open = 1   // 打开方式
        case move = 2  // 移动至常用目录
        case copy = 3  // 拷贝至常用目录
        case unpack = 4  // 解包Assets.car
        case copyPath = 5  // 拷贝路径
        case delete = 6  // 直接删除
    }
    
    var icon: String = ""
    var desc: String = ""
    var type: FeatureType = .newFile
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper <<< type <-- TransformOf<FeatureType, Int> (fromJSON: { value in
            return FeatureType.init(rawValue: value ?? 3) ?? .newFile
        }, toJSON: { value in
            return value?.rawValue ?? 3
        })
    }
}
