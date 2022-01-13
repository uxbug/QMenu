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
        switch QMDataManager.shared.logMode {
        case .weak:
            logButton.selectItem(at: 0)
        case .month:
            logButton.selectItem(at: 1)
        case .manual:
            logButton.selectItem(at: 2)
        }
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
        if index == 0 {
            QMDataManager.shared.logMode = .weak
        } else if index == 1 {
            QMDataManager.shared.logMode = .month
        } else if index == 2 {
            QMDataManager.shared.logMode = .manual
        }
    }
}
