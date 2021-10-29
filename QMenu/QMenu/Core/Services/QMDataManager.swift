//
//  QMDataManager.swift
//  QMenu
//
//  Created by password 1234 on 9/6/21.
//

import Cocoa

enum SkipStyle: Int {
    case system = 0
    case light = 1
    case dark = 2
}

class QMDataManager: NSObject {
    
    static let shared: QMDataManager = QMDataManager.init()
    
    /// 用户电脑名
    var userName: String {
        let home = NSHomeDirectory()
        let paths = (home as NSString).pathComponents
        guard paths.count > 3 else {
            return ""
        }
        if paths[0] == "/" {
            return paths[2]
        }
        return paths[1]
    }
    
    /// 配置
    var config: QMConfigModel? {
        if FileManager.default.fileExists(atPath: configPath()) {
            guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: configPath())), let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                return defaultConfig()
            }
            return QMConfigModel.deserialize(from: dict)
        } else {
            return defaultConfig()
        }
    }
    
    var currentSkip: SkipStyle {
        get {
            let value = UserDefaults.standard.integer(forKey: "QMenu.cureentTheme")
            return SkipStyle.init(rawValue: value) ?? .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "QMenu.cureentTheme")
        }
    }
}

extension QMDataManager {
    
    /// 配置文件路径
    func configPath() -> String {
        let path = "/Users/\(userName)" + "/.QMenu/config.json"
        return path
    }
    
    /// 默认配置
    func defaultConfig() -> QMConfigModel? {
        guard let path = Bundle.main.url(forResource: "config", withExtension: "json"), let data = try? Data.init(contentsOf: path), let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        return QMConfigModel.deserialize(from: dict)
    }
    
    /// 更新功能状态
    /// - Parameters:
    ///   - feature: 功能模型
    ///   - state: 状态
    func updateFeatureState(_ feature: QMFeatureModel, state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.feature.forEach({ model in
            if feature.id == model.id, model.state != state {
                model.state = state
            }
        })
        save(with: cg)
    }
    
    /// 更新功能标题
    /// - Parameters:
    ///   - feature: 功能模型
    ///   - title: 标题
    func updateFeatureTitle(_ feature: QMFeatureModel, title: String) {
        guard let cg = config else {
            return
        }
        cg.feature.forEach({ model in
            if feature.id == model.id, model.title != title {
                model.title = title
            }
        })
        save(with: cg)
    }
    
    /// 更新功能图标
    /// - Parameters:
    ///   - feature: 功能模型
    ///   - iconPath: 图标路径
    func updateFeatureIcon(_ feature: QMFeatureModel, iconPath: String) {
        guard let cg = config else {
            return
        }
        cg.feature.forEach({ model in
            let toPath = iconsPath() + "/" + iconPath.lastPathComponent
            if feature.id == model.id, model.iconPath != toPath {
                if !FileManager.default.fileExists(atPath: toPath), let _ = try? FileManager.default.copyItem(atPath: iconPath, toPath: toPath) {
                    model.iconPath = toPath
                }
            }
        })
        save(with: cg)
    }
    
    /// 更新启动功能状态
    /// - Parameters:
    ///   - launch: 启动功能模型
    ///   - state: 状态
    func updateLaunchState(_ launch: QMLaunchModel, state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.launch.forEach({ model in
            if launch.id == model.id, model.state != state {
                model.state = state
            }
        })
        save(with: cg)
    }
    
    /// 更新启动标题
    /// - Parameters:
    ///   - launch: 启动模型
    ///   - title: 标题
    func updateLaunchTitle(_ launch: QMLaunchModel, title: String) {
        guard let cg = config else {
            return
        }
        cg.launch.forEach({ model in
            if launch.id == model.id, model.title != title {
                model.title = title
            }
        })
        save(with: cg)
    }
    
    /// 更新常用目录状态
    /// - Parameters:
    ///   - directory: 目录模型
    ///   - state: 状态
    func updateDirectoryState(_ directory: QMDirectoryModel, state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.directory.forEach({ model in
            if directory.id == model.id, model.state != state {
                model.state = state
            }
        })
        save(with: cg)
    }
    
    /// 更新常用目录标题
    /// - Parameters:
    ///   - directory: 目录模型
    ///   - title: 标题
    func updateDirectoryTitle(_ directory: QMDirectoryModel, title: String) {
        guard let cg = config else {
            return
        }
        cg.directory.forEach({ model in
            if directory.id == model.id, model.title != title {
                model.title = title
            }
        })
        save(with: cg)
    }
    
    /// 添加常用目录
    /// - Parameter path: 添加目录地址
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
    
    /// 移除常用目录
    /// - Parameter directory: 目录模型
    func removeDirectory(_ directory: QMDirectoryModel) {
        guard let cg = config else {
            return
        }
        for idx in 0..<cg.directory.count {
            let model = cg.directory[idx]
            if model.id == directory.id {
                cg.directory.remove(at: idx)
            }
        }
        save(with: cg)
    }
    
    /// 更新文件模板状态
    /// - Parameters:
    ///   - file: 文件模板模型
    ///   - state: 状态
    func updateNewFileState(_ file: QMFileModel, state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.file.forEach({ model in
            if file.id == model.id, model.state != state {
                model.state = state
            }
        })
        save(with: cg)
    }
    
    /// 更新文件模板标题
    /// - Parameters:
    ///   - file: 文件模板模型
    ///   - title: 标题
    func updateNewFileTitle(_ file: QMFileModel, title: String) {
        guard let cg = config else {
            return
        }
        cg.file.forEach({ model in
            if file.id == model.id, model.title != title {
                model.title = title
            }
        })
        save(with: cg)
    }
    
    /// 添加文件模板
    /// - Parameter path: 文件路径
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
    
    /// 移除文件模板
    /// - Parameter file: 文件模板模型
    func removeFile(_ file: QMFileModel) {
        guard let cg = config else {
            return
        }
        guard let files = config?.file else {
            return
        }
        for idx in 0..<files.count {
            let model = files[idx]
            if model.id == file.id {
                cg.file.remove(at: idx)
                if !model.path.contains("{{path}}"), FileManager.default.fileExists(atPath: model.path) {
                    try? FileManager.default.removeItem(atPath: model.path)
                }
            }
        }
        save(with: cg)
    }
    
    /// 更新新建文件打开状态
    /// - Parameter state: 状态
    func updateFileOpen(state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.autoOpen = state == .on ? true : false
        save(with: cg)
    }
    
    /// 更新常用目录显示状态
    /// - Parameter state: 状态
    func updateDirectoryShow(state: NSControl.StateValue) {
        guard let cg = config else {
            return
        }
        cg.showDirectory = state == .on ? true : false
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
    
    func iconsPath() -> String {
        let path = "/Users/\(userName)" + "/.QMenu/icon"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
}
