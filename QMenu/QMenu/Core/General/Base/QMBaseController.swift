//
//  QMBaseController.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa
import FinderSync
import macOSThemeKit

class QMBaseController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
    }
    
    var isExtensionEnabled: Bool {  // 检测扩展启用状态
        return FIFinderSyncController.isExtensionEnabled
    }
    
    func showExtensionManagementInterface() {   // 跳转扩展配置页面
        FIFinderSyncController.showExtensionManagementInterface()
    }
}
