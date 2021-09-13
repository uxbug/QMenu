//
//  QMDataManager.swift
//  QMenu
//
//  Created by password 1234 on 9/6/21.
//

import Cocoa

class QMDataManager: NSObject {
    
    static let shared: QMDataManager = QMDataManager.init()
    
    var userName: String {
        guard let name = getlogin() else {
            return ""
        }
        return String.init(cString: name)
    }
    
    var config: QMConfigModel? {
        if FileManager.default.fileExists(atPath: configPath()) {
            guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: configPath())), let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                return nil
            }
            return QMConfigModel.deserialize(from: dict)
        } else {
            return defaultConfig()
        }
    }
}

extension QMDataManager {
    func configPath() -> String {
        let path = "/Users/\(userName)" + "/.QMenu/config.json"
        return path
    }
    
    func defaultConfig() -> QMConfigModel? {
        guard let path = Bundle.main.url(forResource: "config", withExtension: "json"), let data = try? Data.init(contentsOf: path), let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        return QMConfigModel.deserialize(from: dict)
    }
    
    func updateFeatureState(_ feature: QMFeatureModel, state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.feature.forEach({ model in
            if feature.id == model.id {
                model.state = state
            }
        })
        save(with: cg)
    }
    
    func updateOpenState(_ feature: QMLaunchModel, state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.launch.forEach({ model in
            if feature.id == model.id {
                model.state = state
            }
        })
        save(with: cg)
    }
    
    func updateDirectoryState(_ feature: QMDirectoryModel, state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.directory.forEach({ model in
            if feature.id == model.id {
                model.state = state
            }
        })
        save(with: cg)
    }
    
    func addDirectory(_ path: String) {
        guard let cg = config else {
            return
        }
        let directory = QMDirectoryModel.init()
        directory.path = path
        directory.id = Date.timestamp
        directory.state = .on
        directory.title = path.lastPathComponent
        cg.directory.append(directory)
        save(with: cg)
    }
    
    func removeDirectory(_ feature: QMDirectoryModel) {
        guard let cg = config else {
            return
        }
        for idx in 0..<cg.directory.count {
            let model = cg.directory[idx]
            if model.id == feature.id {
                cg.directory.remove(at: idx)
            }
        }
        save(with: cg)
    }
    
    func updateNewFileState(_ feature: QMFileModel, state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.file.forEach({ model in
            if feature.id == model.id {
                model.state = state
            }
        })
        save(with: cg)
    }
    
    func addNewFile(_ path: String) {
        guard let cg = config else {
            return
        }
        let file = QMFileModel.init()
        file.state = .on
        file.title = path.lastPathComponent.deletingPathExtension
        file.suffix = path.pathExtension
        file.id = Date.timestamp
        let tempPath = fileTempletePath() + "/" + file.title + ".\(file.suffix)"
        do {
            try FileManager.default.copyItem(atPath: path, toPath: tempPath)
            file.path = tempPath
            cg.file.append(file)
            save(with: cg)
        } catch {
            QMLoger.addLog("添加模板失败: \(path)")
        }
    }
    
    func removeFile(_ feature: QMFileModel) {
        guard let cg = config else {
            return
        }
        guard let file = config?.file else {
            return
        }
        for idx in 0..<file.count {
            let model = file[idx]
            if model.id == feature.id {
                cg.file.remove(at: idx)
                if !model.path.contains("{{path}}"), FileManager.default.fileExists(atPath: model.path) {
                    try? FileManager.default.removeItem(atPath: model.path)
                }
            }
        }
        save(with: cg)
    }
}

fileprivate extension QMDataManager {
    func save(with config: QMConfigModel) {
        let json = config.toJSONString()
        if FileManager.default.fileExists(atPath: configPath()) {
            try? FileManager.default.removeItem(atPath: configPath())
        }
        FileManager.default.createFile(atPath: configPath(), contents: json?.data(using: .utf8), attributes: nil)
    }
    
    func fileTempletePath() -> String {
        let path = "/Users/\(userName)" + "/.QMenu/template"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
}
