//
//  QMBaseController.swift
//  QMenu
//
//  Created by password 1234 on 9/3/21.
//

import Cocoa

class QMBaseController: NSViewController {

    var hasView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
    }
    
    func updateFinderSync() {
        let bundleId = "com.apple.finder"
        let apps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId)
        apps.forEach { app in
            let kill = "kill -s 9 \(app.processIdentifier)"
            let value = commmand(argument: kill)
            QMLoger.addLog("重启finder: \(value)")
        }
    }
    
    func commmand(argument: String) -> String {
        let process = Process.init()
        process.launchPath = "/usr/bin/"
        process.arguments = [argument]
        let pipe = Pipe()
        process.standardOutput = pipe
          
        if #available(macOS 10.13, *) {
            try? process.run()
        } else {
            process.launch()
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        return output
    }
}
