//
//  QMRunner.swift
//  QMenuTarget
//
//  Created by password 1234 on 9/9/21.
//

import Foundation
import Carbon

struct QMRunner {
    var scriptURL: URL? {
        return try? FileManager.default.url(for: .applicationScriptsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    fileprivate var runnerScriptURL: URL? {
        return scriptURL?.appendingPathComponent("runner.scpt")
    }

    init() {
        moveScriptFile()
    }
    
    func launch(with appName: String, selectURLs: [URL], mode: QMFeatureModel.Mode) {
        switch mode {
        case .editor:
            let name = appName.nameSpaceEscaped()
            var openCommand = "open -a \(name)"
            selectURLs.map {
                $0.path
            }.forEach {
                openCommand += " " + $0.specialCharEscaped()
            }
            guard let scriptURL = runnerScriptURL else {
                QMLoger.addLog("打开\(appName)失败: 未能获取脚本文件")
                return
            }
            guard FileManager.default.fileExists(atPath: scriptURL.path) else {
                QMLoger.addLog("打开\(appName)失败: 未能获取脚本文件")
                return
            }
            guard let script = try? NSUserAppleScriptTask(url: scriptURL) else {
                QMLoger.addLog("打开\(appName)失败: 未能获取脚本文件")
                return
            }
            let event = getScriptEvent(functionName: "openApp", openCommand)
            script.execute(withAppleEvent: event) { (appleEvent, error) in
                if let error = error {
                    QMLoger.addLog("打开\(appName)失败: \(error.localizedDescription)")
                }
            }
        case .terminal:
            guard var url = selectURLs.first else {
                QMLoger.addLog("打开\(appName)失败: 未能获取选中文件路径")
                return
            }
            var isDirectory: ObjCBool = false
            guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
                QMLoger.addLog("打开\(appName)失败: 未能获取脚本文件")
                return
            }
            if isDirectory.boolValue == false {
                url.deleteLastPathComponent()
            }
            var openCommand = getOpenCommand(appName)
            openCommand += " " + url.path.specialCharEscaped()
            guard let scriptURL = runnerScriptURL else {
                QMLoger.addLog("打开\(appName)失败: 未能获取脚本文件")
                return
            }
            guard FileManager.default.fileExists(atPath: scriptURL.path) else {
                QMLoger.addLog("打开\(appName)失败: 未能获取脚本文件")
                return
            }
            guard let script = try? NSUserAppleScriptTask(url: scriptURL) else {
                QMLoger.addLog("打开\(appName)失败: 未能获取脚本文件")
                return
            }
            let event = getScriptEvent(functionName: "openApp", openCommand)
            script.execute(withAppleEvent: event) { (appleEvent, error) in
                if let error = error {
                    QMLoger.addLog("打开\(appName)失败: \(error.localizedDescription)")
                }
            }
        }
    }
    
}

fileprivate extension QMRunner {
    func moveScriptFile() {
        guard let path = Bundle.main.path(forResource: "runner", ofType: "scpt"), let toPath = runnerScriptURL?.path else {
            QMLoger.addLog("脚本拷贝失败: \(runnerScriptURL)")
            return
        }
        if !FileManager.default.fileExists(atPath: toPath) {
            do {
                try FileManager.default.copyItem(atPath: path, toPath: toPath)
            } catch {
                QMLoger.addLog("脚本拷贝失败")
            }
        } else {    // 已存在判断文件内容是否一致
            let file = try? String.init(contentsOfFile: toPath)
            let currentFile = try? String.init(contentsOfFile: path)
            if file != currentFile {
                do {
                    try FileManager.default.removeItem(atPath: toPath)
                    try FileManager.default.copyItem(atPath: path, toPath: toPath)
                    QMLoger.addLog("脚本已更新")
                } catch {
                    QMLoger.addLog("脚本更新失败: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getOpenCommand(_ app: String, escapeCount: Int = 1) -> String {
        if app == "Alacritty" {
            return "open -na Alacritty --args --working-directory"
        } else if app == "kitty" {
            return "open -na kitty --args --directory"
        } else {
            return "open -a \(app.nameSpaceEscaped(escapeCount))"
        }
    }
    
    func getScriptEvent(functionName: String, _ parameter: String) -> NSAppleEventDescriptor {
        let parameters = NSAppleEventDescriptor.list()
        parameters.insert(NSAppleEventDescriptor(string: parameter), at: 0)

        let event = NSAppleEventDescriptor(
            eventClass: AEEventClass(kASAppleScriptSuite),
            eventID: AEEventID(kASSubroutineEvent),
            targetDescriptor: nil,
            returnID: AEReturnID(kAutoGenerateReturnID),
            transactionID: AETransactionID(kAnyTransactionID)
        )
        event.setDescriptor(NSAppleEventDescriptor(string: functionName), forKeyword: AEKeyword(keyASSubroutineName))
        event.setDescriptor(parameters, forKeyword: AEKeyword(keyDirectObject))
        return event
    }
}
