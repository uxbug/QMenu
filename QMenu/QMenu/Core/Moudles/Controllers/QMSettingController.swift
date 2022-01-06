//
//  QMSettingController.swift
//  QMenu
//
//  Created by password 1234 on 1/6/22.
//

import Cocoa
import macOSThemeKit

class QMSettingController: QMBaseController {
    
    @IBOutlet weak var themeButton: NSPopUpButton!
    @IBOutlet weak var logButton: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeButton.selectItem(at: QMDataManager.shared.currentSkip.rawValue)
        logButton.selectItem(at: QMDataManager.shared.logMode.rawValue)
    }
    
    @IBAction func didThemeChange(_ sender: NSPopUpButton) {
        let index = sender.indexOfSelectedItem
        let skip = SkipStyle.init(rawValue: index) ?? .system
        switch skip {
        case .system:
            ThemeManager.systemTheme.apply()
        case .light:
            ThemeManager.lightTheme.apply()
        case .dark:
            ThemeManager.darkTheme.apply()
        }
    }
    
    @IBAction func didLogChange(_ sender: NSPopUpButton) {
        let index = sender.indexOfSelectedItem
        let mode = QMLogMode.init(rawValue: index) ?? .weak
        QMDataManager.shared.logMode = mode
    }
}
