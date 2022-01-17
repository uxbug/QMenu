//
//  QMFeatureModel.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa
import HandyJSON

enum FeatureType: Int {
    case newFile = 0    // 文件模板
    case launch = 1   // 打开方式
    case move = 2  // 移动至常用目录
    case copy = 3  // 拷贝至常用目录
    case copyPath = 4  // 拷贝路径
    case delete = 5  // 直接删除
}

class QMFeatureModel: QMBaseModel {
    
    var icon: String = ""   // 默认图标
    var desc: String = ""   // 描述
    var type: FeatureType = .newFile    // 类型
    var iconPath: String = ""   // 自定义图标
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper <<< type <-- TransformOf<FeatureType, Int> (fromJSON: { value in
            return FeatureType.init(rawValue: value ?? 0)
        }, toJSON: { value in
            return value?.rawValue ?? 0
        })
    }
}
