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
