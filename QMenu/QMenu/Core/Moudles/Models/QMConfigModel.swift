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
    var open: [QMFeatureModel] = []
    var directory: [QMFeatureModel] = []
    var file: [QMFeatureModel] = []
    var autoOpen: Bool = true
    
    required override init() {
        
    }
    
}