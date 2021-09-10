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
    
    var config: QMConfigModel?
    
    override init() {
        super.init()
        if FileManager.default.fileExists(atPath: configPath()) {
            guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: configPath())), let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                return
            }
            config = QMConfigModel.deserialize(from: dict)
        } else {
            config = defaultConfig()
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
        config?.feature.forEach({ model in
            if feature.id == model.id {
                model.state = state
            }
        })
        saveConfig()
    }
    
    func updateOpenState(_ feature: QMOpenModel, state: NSControl.StateValue) {
        config?.open.forEach({ model in
            if feature.id == model.id {
                model.state = state
            }
        })
        saveConfig()
    }
    
    func updateDirectoryState(_ feature: QMDirectoryModel, state: NSControl.StateValue) {
        config?.directory.forEach({ model in
            if feature.id == model.id {
                model.state = state
            }
        })
        saveConfig()
    }
    
    func addDirectory(_ path: String) {
        let directory = QMDirectoryModel.init()
        directory.path = path
        directory.id = Date.timestamp
        directory.state = .on
        directory.title = path.lastPathComponent
        config?.directory.append(directory)
        saveConfig()
    }
    
    func removeDirectory(_ feature: QMDirectoryModel) {
        guard let directory = config?.directory else {
            return
        }
        for idx in 0..<directory.count {
            let model = directory[idx]
            if model.id == feature.id {
                config?.directory.remove(at: idx)
            }
        }
        saveConfig()
    }
    
    func updateNewFileState(_ feature: QMFileModel, state: NSControl.StateValue) {
        config?.file.forEach({ model in
            if feature.id == model.id {
                model.state = state
            }
        })
        saveConfig()
    }
    
    func addNewFile(_ path: String) {
        let file = QMFileModel.init()
        file.state = .on
        file.title = path.lastPathComponent.deletingPathExtension
        file.suffix = path.pathExtension
        file.id = Date.timestamp
        let tempPath = fileTempletePath() + "/" + file.title + ".\(file.suffix)"
        do {
            try FileManager.default.copyItem(atPath: path, toPath: tempPath)
            file.path = tempPath
            config?.file.append(file)
            saveConfig()
        } catch {
            QMLoger.addLog("添加模板失败: \(path)")
        }
    }
    
    func removeFile(_ feature: QMFileModel) {
        guard let file = config?.file else {
            return
        }
        for idx in 0..<file.count {
            let model = file[idx]
            if model.id == feature.id {
                config?.file.remove(at: idx)
                if !model.path.contains("{{path}}"), FileManager.default.fileExists(atPath: model.path) {
                    try? FileManager.default.removeItem(atPath: model.path)
                }
            }
        }
        saveConfig()
    }
}

fileprivate extension QMDataManager {
    func saveConfig() {
        let json = config?.toJSONString()
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
