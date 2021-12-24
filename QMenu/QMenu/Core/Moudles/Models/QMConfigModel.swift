//
//  QMConfigModel.swift
//  QMenu
//
//  Created by password 1234 on 9/6/21.
//

import Cocoa
import HandyJSON

class QMConfigModel: NSObject, HandyJSON {
    
    var feature: [QMFeatureModel] = []
    var launch: [QMLaunchModel] = []
    var directory: [QMDirectoryModel] = []
    var file: [QMFileModel] = []
    var autoOpen: Bool = true   // 自动打开文件
    var showDirectory: Bool = true   // 显示常用目录
    
    required override init() {
        
    }
    
}
