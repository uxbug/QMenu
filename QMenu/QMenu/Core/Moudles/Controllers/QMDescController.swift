//
//  QMDescController.swift
//  QMenu
//
//  Created by password 1234 on 9/6/21.
//

import Cocoa

class QMDescController: QMBaseController {

    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
}

fileprivate extension QMDescController {
    func makeUI() {
        textView.textContainerInset = NSSize.init(width: 10, height: 10)
        view.backgroundColor = .white
        // 配置超链接
        let att = NSMutableAttributedString.init(attributedString: textView.attributedString())
        let launch = "右键菜单扩展"
        let launchRange = (textView.string as NSString).range(of: launch)
        att.addAttributes([NSAttributedString.Key.link: "preferences://"], range: launchRange)
        let path = "~/Library/Application Scripts/com.liyb.QMenu.QMenuTarget"
        let pathRange = (textView.string as NSString).range(of: path)
        att.addAttributes([NSAttributedString.Key.link: "path://"], range: pathRange)
        textView.textStorage?.setAttributedString(att)
        
        textView.delegate = self
    }
    
    @IBAction func exportScriptFile(_ sender: Any) {
        let panel = NSOpenPanel.init()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.begin { resonse in
            switch resonse {
            case .OK:
                guard let path = panel.url?.path else {
                    return
                }
                if let terminal = Bundle.main.path(forResource: "runner", ofType: "scpt") {
                    let filePath = path + "/runner.scpt"
                    try? FileManager.default.copyItem(atPath: terminal, toPath: filePath)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func logList(_ sender: Any) {
        let log = QMLogController.init()
        presentAsSheet(log)
    }
}

extension QMDescController: NSTextViewDelegate {
    func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        guard let url = link as? String else {
            return false
        }
        if url.hasPrefix("preferences") {   // 启用插件
            showExtensionManagementInterface()
        } else if url.hasPrefix("path") {   // 跳转脚本路径
            guard let scriptURL = try? FileManager.default.url(for: .applicationScriptsDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
                return false
            }
            var path = scriptURL.path.deletingLastPathComponent
            path = path.appending("com.liyb.QMenu.QMenuTarget")
            NSWorkspace.shared.open(URL.init(fileURLWithPath: path))
        }
        return true
    }
}
