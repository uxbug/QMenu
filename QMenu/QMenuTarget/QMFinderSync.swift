//
//  QMFinderSync.swift
//  QMenuTarget
//
//  Created by password 1234 on 8/30/21.
//

import Cocoa
import FinderSync

class QMFinderSync: FIFinderSync {

    var myFolderURL = URL(fileURLWithPath: "/")
    var runner: QMRunner!
    
    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
        runner = QMRunner.init()
    }
    
    // MARK: - Menu and toolbar item support
    override var toolbarItemName: String {
        return "QMenu"
    }
    
    override var toolbarItemToolTip: String {
        return "QMenu"
    }
    
    override var toolbarItemImage: NSImage {
        return NSImage(named: NSImage.menuOnStateTemplateName)!
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        return createMenu()
    }
}

// MARK: 工具方法
fileprivate extension QMFinderSync {
    
    /// 创建新路径
    /// - Parameters:
    ///   - isFile: 是否是文件
    ///   - path: 基路径
    ///   - name: 文件名/文件夹名
    ///   - suffix: 文件后缀
    /// - Returns: 返回生成的路径
    func createPath(isFile: Bool, path: String, name:String = "未命名", suffix: String? = nil) -> String {
        var result: String = ""
        var index = 1
        if isFile {
            let s = suffix != nil ? ".\(suffix!)" : ""
            result = path + "/\(name)\(s)"
            while FileManager.default.fileExists(atPath: result) {
                result = path + "/\(name) \(index)\(s)"
                index += 1
            }
        } else {
            result = path + "/\(name)"
            while FileManager.default.fileExists(atPath: result) {
                result = path + "/\(name) \(index)"
                index += 1
            }
        }
        return result
    }
    
    func createMenu() -> NSMenu {
        let menu = NSMenu.init(title: "QMenu")
        if let config = QMDataManager.shared.config {
            let features = config.feature.filter({ $0.state == .on })
            for feature in features {
                if feature.type == .newFile {   // 文件模板
                    let item = NSMenuItem.init()
                    item.title = feature.title
                    item.tag = feature.id
                    item.submenu = NSMenu.init(title: feature.title)
                    let files = config.file.filter({ $0.state == .on })
                    if files.count > 0 {
                        files.forEach { model in
                            let it = NSMenuItem.init(title: model.title, action: #selector(createNewFile(_:)), keyEquivalent: "")
                            it.tag = model.id
                            item.submenu?.addItem(it)
                        }
                        menu.addItem(item)
                    }
                } else if feature.type == .open {   // 打开方式
                    let item = NSMenuItem.init()
                    item.title = feature.title
                    item.tag = feature.id
                    item.submenu = NSMenu.init(title: feature.title)
                    let opens = config.open.filter({ $0.state == .on && LSCopyApplicationURLsForBundleIdentifier($0.bundleId as CFString, nil) != nil })
                    if opens.count > 0 {
                        opens.forEach { model in
                            let it = NSMenuItem.init(title: model.title, action: #selector(openItem(_:)), keyEquivalent: "")
                            it.tag = model.id
                            item.submenu?.addItem(it)
                        }
                        menu.addItem(item)
                    }
                } else if feature.type == .move {   // 移动至常用目录
                    let item = NSMenuItem.init()
                    item.title = feature.title
                    item.tag = feature.id
                    item.submenu = NSMenu.init(title: feature.title)
                    let directorys = config.directory.filter({ $0.state == .on })
                    if directorys.count > 0 {
                        directorys.forEach { model in
                            let it = NSMenuItem.init(title: model.title, action: #selector(moveToDirectory(_:)), keyEquivalent: "")
                            it.tag = model.id
                            item.submenu?.addItem(it)
                        }
                        menu.addItem(item)
                    }
                } else if feature.type == .copy {   // 拷贝至常用目录
                    let item = NSMenuItem.init()
                    item.title = feature.title
                    item.tag = feature.id
                    item.submenu = NSMenu.init(title: feature.title)
                    let directorys = config.directory.filter({ $0.state == .on })
                    if directorys.count > 0 {
                        directorys.forEach { model in
                            let it = NSMenuItem.init(title: model.title, action: #selector(copyToDirectory(_:)), keyEquivalent: "")
                            it.tag = model.id
                            item.submenu?.addItem(it)
                        }
                        menu.addItem(item)
                    }
                } else if feature.type == .unpack { // 解包Assets.car
                    if let items = FIFinderSyncController.default().selectedItemURLs() {
                        var containsAssetCar: Bool = false
                        for item in items {
                            if item.path.hasSuffix(".car") {
                                containsAssetCar = true
                            }
                        }
                        if containsAssetCar {
                            let item = NSMenuItem.init(title: feature.title, action: #selector(unPackAssetCarFile), keyEquivalent: "")
                            item.tag = feature.id
                            menu.addItem(item)
                        }
                    }
                } else if feature.type == .copyPath {   // 拷贝路径
                    let item = NSMenuItem.init(title: feature.title, action: #selector(copyPath), keyEquivalent: "")
                    item.tag = feature.id
                    menu.addItem(item)
                } else if feature.type == .delete { // 直接删除文件
                    let item = NSMenuItem.init(title: feature.title, action: #selector(deleteItem), keyEquivalent: "")
                    item.tag = feature.id
                    menu.addItem(item)
                }
            }
        }
        return menu
    }
}

// MARK: 事件
fileprivate extension QMFinderSync {
    // 拷贝路径
    @objc func copyPath() {
        guard let items = FIFinderSyncController.default().selectedItemURLs() else {
            QMLoger.addLog("拷贝路径失败，未获取到选中路径")
            return
        }
        var paths: String = ""
        for i in 0..<items.count {
            let path = items[i].path
            i == items.count - 1 ? paths.append(path) : paths.append("\(path)\n")
        }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(paths, forType: .string)
        QMLoger.addLog("拷贝路径成功")
    }
    
    // 解包Assets.car
    @objc func unPackAssetCarFile() {
        guard let items = FIFinderSyncController.default().selectedItemURLs() else {
            QMLoger.addLog("解包AssetCar失败，未获取到选中路径")
            return
        }
        guard let target = FIFinderSyncController.default().targetedURL() else {
            QMLoger.addLog("解包AssetCar失败，未获取到选中路径")
            return
        }
        guard let carToolPath = Bundle.main.path(forResource: "cartool", ofType: "") else {
            QMLoger.addLog("解包AssetCar失败，未获取到cartool路径")
            return
        }
        for item in items {
            if item.path.hasSuffix(".car") {
                let dir = createPath(isFile: false, path: target.path, name: "Assets")
                if !FileManager.default.fileExists(atPath: dir) {
                    try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
                }
                QMShell.execmd(carToolPath, arguments: [item.path, dir]) { value in
                    QMLoger.addLog("解包AssetCar成功")
                }
            }
        }
    }
    
    // 移动至
    @objc func moveToDirectory(_ item: NSMenuItem) {
        guard let model = QMDataManager.shared.config?.directory.first(where: { $0.id == item.tag }) else {
            QMLoger.addLog("获取绑定模型错误: \(item.title)")
            return
        }
        guard let items = FIFinderSyncController.default().selectedItemURLs() else {
            QMLoger.addLog("拷贝至常用目录失败，未获取到选中路径")
            return
        }
        var toPath = model.path
        if toPath.contains("{{username}}") {
            toPath = model.path.replacingOccurrences(of: "{{username}}", with: QMDataManager.shared.userName)
        }
        for item in items {
            let lastPath = item.path.lastPathComponent
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: item.path, isDirectory: &isDirectory) {
                toPath = createPath(isFile: !isDirectory.boolValue, path: toPath, name: lastPath)
            }
            do {
                try FileManager.default.moveItem(atPath: item.path, toPath: toPath)
            } catch {
                QMLoger.addLog("移动至常用目录失败，\(error.localizedDescription)")
            }
        }
    }
    
    // 拷贝至
    @objc func copyToDirectory(_ item: NSMenuItem) {
        guard let model = QMDataManager.shared.config?.directory.first(where: { $0.id == item.tag }) else {
            QMLoger.addLog("获取绑定模型错误: \(item.title)")
            return
        }
        guard let items = FIFinderSyncController.default().selectedItemURLs() else {
            QMLoger.addLog("拷贝至常用目录失败，未获取到选中路径")
            return
        }
        var toPath = model.path
        if toPath.contains("{{username}}") {
            toPath = model.path.replacingOccurrences(of: "{{username}}", with: QMDataManager.shared.userName)
        }
        for item in items {
            let lastPath = item.path.lastPathComponent
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: item.path, isDirectory: &isDirectory) {
                toPath = createPath(isFile: !isDirectory.boolValue, path: toPath, name: lastPath)
            }
            do {
                try FileManager.default.copyItem(atPath: item.path, toPath: toPath)
            } catch {
                QMLoger.addLog("拷贝至常用目录失败，\(error.localizedDescription)")
            }
        }
    }
    
    // 新建文件
    @objc func createNewFile(_ item: NSMenuItem) {
        guard let model = QMDataManager.shared.config?.file.first(where: { $0.id == item.tag }) else {
            QMLoger.addLog("获取绑定模型错误: \(item.title)")
            return
        }
        guard let target = FIFinderSyncController.default().targetedURL() else {
            QMLoger.addLog("创建文件失败，未获取到选中路径")
            return
        }
        var path = model.path
        if model.path.contains("{{path}}") {
            let file = model.path.replacingOccurrences(of: "{{path}}", with: "")
            path = Bundle.main.path(forResource: file, ofType: model.suffix) ?? ""
        }
        let fileName = path.lastPathComponent.deletingPathExtension
        let toPath = createPath(isFile: true, path: target.path, name: fileName, suffix: model.suffix)
        do {
            try FileManager.default.copyItem(atPath: path, toPath: toPath)
            if QMDataManager.shared.config?.autoOpen ?? true {
                NSWorkspace.shared.open(URL.init(fileURLWithPath: toPath))
            }
        } catch {
            QMLoger.addLog("创建文件失败，\(error.localizedDescription)")
        }
    }
    
    // 打开
    @objc func openItem(_ item: NSMenuItem) {
        guard let model = QMDataManager.shared.config?.open.first(where: { $0.id == item.tag }) else {
            QMLoger.addLog("获取绑定模型错误: \(item.title)")
            return
        }
        guard let urls = FIFinderSyncController.default().selectedItemURLs() else {
            QMLoger.addLog("打开\(model.bundleId)失败，未获取到选中路径")
            return
        }
        runner.launch(with: model.title, selectURLs: urls, mode: model.mode)
    }
    
    // 删除
    @objc func deleteItem() {
        guard let items = FIFinderSyncController.default().selectedItemURLs() else {
            QMLoger.addLog("删除文件失败，未获取到选中路径")
            return
        }
        items.forEach { url in
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }
}
