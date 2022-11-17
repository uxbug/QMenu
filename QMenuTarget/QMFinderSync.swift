//
//  QMFinderSync.swift
//  QMenuTarget
//
//  Created by password 1234 on 8/30/21.
//

import Cocoa
import FinderSync

class QMFinderSync: FIFinderSync {

    var runner: QMRunner!
    
    override init() {
        super.init()
        let finderSync = FIFinderSyncController.default()
        if let mountedVolumes = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: [.skipHiddenVolumes]) {
            finderSync.directoryURLs = Set<URL>(mountedVolumes)
        }
        // Monitor volumes
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(forName: NSWorkspace.didMountNotification, object: nil, queue: .main) { notification in
            if let volumeURL = notification.userInfo?[NSWorkspace.volumeURLUserInfoKey] as? URL {
                finderSync.directoryURLs.insert(volumeURL)
            }
        }
        runner = QMRunner.init()
    }
    
    // MARK: - Menu and toolbar item support
    override var toolbarItemName: String {
        return "右键菜单"
    }
    
    override var toolbarItemToolTip: String {
        return "右键菜单"
    }
    
    override var toolbarItemImage: NSImage {
        return NSImage(named: "toolbar_logo")!
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        return createMenu()
    }
}

// MARK: 工具方法
fileprivate extension QMFinderSync {

    /// 常用目录menu tag
    struct Tag {
        static let useDirectory: Int = 203023093
        static let addDirectory: Int = 203023094
        static let addFile: Int = 203023095
    }
    
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
    
    /// 配置右键菜单
    /// - Returns: 右键菜单
    func createMenu() -> NSMenu {
        let menu = NSMenu.init(title: "QMenu")
        var hasAddDirectory: Bool = false   // 是否添加过常用目录
        if let config = QMDataManager.shared.config {
            let features = config.feature.filter({ $0.state == .on })
            if features.count > 0 {
                for feature in features {
                    if feature.type == .newFile {   // 文件模板
                        configNewFileMenuItem(config, feature: feature, menu: menu)
                    } else if feature.type == .launch {   // 打开方式
                        configLaunchMenuItem(config, feature: feature, menu: menu)
                    } else if config.showDirectory && !hasAddDirectory { // 常用目录
                        configDirectoryMenuItem(config, menu: menu)
                        hasAddDirectory = true
                    } else if feature.type == .move {   // 移动至常用目录
                        configMoveDirectoryMenuItem(config, feature: feature, menu: menu)
                    } else if feature.type == .copy {   // 拷贝至常用目录
                        configCopyDirectoryMenuItem(config, feature: feature, menu: menu)
                    } else if feature.type == .copyPath {   // 拷贝路径
                        configCopyPathMenuItem(config, feature: feature, menu: menu)
                    } else if feature.type == .delete { // 直接删除文件
                        configDeleteFileMenuItem(config, feature: feature, menu: menu)
                    } else if feature.type == .trash { // 废纸篓
                        configTrashMenuItem(config, feature: feature, menu: menu)
                    }
                }
            } else if config.showDirectory {
                configDirectoryMenuItem(config, menu: menu)
            }
        }
        return menu
    }
    
    /// 配置新建文件菜单
    func configNewFileMenuItem(_ config: QMConfigModel, feature: QMFeatureModel, menu: NSMenu) {
        let item = NSMenuItem.init()
        item.title = feature.title
        item.tag = feature.id
        item.image = NSImage.init(named: feature.icon)
        item.submenu = NSMenu.init(title: feature.title)
        let files = config.file.filter({ $0.state == .on })
        if files.count > 0 {
            files.forEach { model in
                let it = NSMenuItem.init(title: model.title, action: #selector(createNewFile(_:)), keyEquivalent: "")
                it.tag = model.id
                var image: NSImage?
                if model.iconPath.count > 0 {
                    image = NSImage.init(contentsOfFile: model.iconPath)
                } else {
                    image = NSImage.init(named: model.icon)
                }
                if image?.size.width ?? 0 > 60, image?.size.height ?? 0 > 60 {
                    image = image?.resize(for: CGSize.init(width: 60, height: 60))
                }
                if image == nil, model.icon.count <= 0, model.path.count > 0 {  // 获取系统默认图标
                    image = NSWorkspace.shared.icon(forFile: model.path).resize(for: CGSize.init(width: 20, height: 20))
                }
                it.image = image
                item.submenu?.addItem(it)
            }
        }
        let it = NSMenuItem(title: "添加模板", action: #selector(addNewFile(_:)), keyEquivalent: "")
        it.tag = Tag.addFile
        it.image = NSImage(named: "feature_add")
        item.submenu?.addItem(it)
        menu.addItem(item)
    }
    
    /// 配置打开...菜单
    func configLaunchMenuItem(_ config: QMConfigModel, feature: QMFeatureModel, menu: NSMenu) {
        let item = NSMenuItem.init()
        item.title = feature.title
        item.tag = feature.id
        item.image = NSImage.init(named: feature.icon)
        item.submenu = NSMenu.init(title: feature.title)
//        var launchs = config.launch.filter({ $0.state == .on})  //  && LSCopyApplicationURLsForBundleIdentifier($0.bundleId as CFString, nil) != nil
        var launchs: [QMLaunchModel] = []
        for launch in config.launch {
            if launch.state == .on {
                let bundleIds = launch.bundleId.components(separatedBy: "{{&}}")
                for bundleId in bundleIds {
                    if LSCopyApplicationURLsForBundleIdentifier(bundleId as CFString, nil) != nil {
                        launchs.append(launch)
                    }
                }
            }
        }
        if launchs.count > 0 {
            launchs.forEach { model in
                let it = NSMenuItem.init(title: model.title, action: #selector(openItem(_:)), keyEquivalent: "")
                it.tag = model.id
                var image: NSImage?
                if model.iconPath.count > 0 {
                    image = NSImage.init(contentsOfFile: model.iconPath)
                } else {
                    image = NSImage.init(named: model.icon)
                }
                if image?.size.width ?? 0 > 60, image?.size.height ?? 0 > 60 {
                    image = image?.resize(for: CGSize.init(width: 60, height: 60))
                }
                it.image = image
                item.submenu?.addItem(it)
            }
            menu.addItem(item)
        }
    }
    
    /// 配置移动至菜单
    func configMoveDirectoryMenuItem(_ config: QMConfigModel, feature: QMFeatureModel, menu: NSMenu) {
        configSubMenuItem(config, feature: feature, menu: menu, action: #selector(moveToDirectory(_:)))
    }
    
    /// 配置拷贝至菜单
    func configCopyDirectoryMenuItem(_ config: QMConfigModel, feature: QMFeatureModel, menu: NSMenu) {
        configSubMenuItem(config, feature: feature, menu: menu, action: #selector(copyToDirectory(_:)))
    }
    
    /// 配置拷贝路径菜单
    func configCopyPathMenuItem(_ config: QMConfigModel, feature: QMFeatureModel, menu: NSMenu) {
        configMenuItem(config, feature: feature, menu: menu, action: #selector(copyPath))
    }
    
    /// 配置直接删除菜单
    func configDeleteFileMenuItem(_ config: QMConfigModel, feature: QMFeatureModel, menu: NSMenu) {
        configMenuItem(config, feature: feature, menu: menu, action: #selector(deleteItem))
    }
    
    // 配置清理垃圾篓菜单
    func configTrashMenuItem(_ config: QMConfigModel, feature: QMFeatureModel, menu: NSMenu) {
        configMenuItem(config, feature: feature, menu: menu, action: #selector(cleanTrash))
    }
    
    /// 配置常用目录菜单
    func configDirectoryMenuItem(_ config: QMConfigModel, menu: NSMenu) {
        let item = NSMenuItem.init()
        item.title = "常用目录"
        item.tag = Tag.useDirectory
        item.image = NSImage.init(named: "tab_directory_select")
        item.submenu = NSMenu.init(title: "常用目录")
        let directorys = config.directory.filter({ $0.state == .on })
        if directorys.count > 0 {
            directorys.forEach { model in
                let it = NSMenuItem.init(title: model.title, action: #selector(openDirectory(_:)), keyEquivalent: "")
                it.tag = model.id
                it.image = NSImage.init(named: "directory")
                item.submenu?.addItem(it)
            }
        }
        let it = NSMenuItem(title: "添加目录", action: #selector(addNewDirectory(_:)), keyEquivalent: "")
        it.tag = Tag.addDirectory
        it.image = NSImage(named: "feature_add")
        item.submenu?.addItem(it)
        menu.addItem(item)
    }
    
    func configMenuItem(_ config: QMConfigModel, feature: QMFeatureModel, menu: NSMenu, action: Selector) {
        let item = NSMenuItem.init(title: feature.title, action: action, keyEquivalent: "")
        item.tag = feature.id
        var image: NSImage?
        if feature.iconPath.count > 0 {
            image = NSImage.init(contentsOfFile: feature.iconPath)
        } else {
            image = NSImage.init(named: feature.icon)
        }
        if image?.size.width ?? 0 > 60, image?.size.height ?? 0 > 60 {
            image = image?.resize(for: CGSize.init(width: 60, height: 60))
        }
        item.image = image
        menu.addItem(item)
    }
    
    func configSubMenuItem(_ config: QMConfigModel, feature: QMFeatureModel, menu: NSMenu, action: Selector) {
        let item = NSMenuItem.init()
        item.title = feature.title
        item.tag = feature.id
        item.image = NSImage.init(named: feature.icon)
        item.submenu = NSMenu.init(title: feature.title)
        let directorys = config.directory.filter({ $0.state == .on })
        if directorys.count > 0 {
            directorys.forEach { model in
                let it = NSMenuItem.init(title: model.title, action: action, keyEquivalent: "")
                it.tag = model.id
                it.image = NSImage.init(named: "directory")
                item.submenu?.addItem(it)
            }
            menu.addItem(item)
        }
    }
    
    /// 跳转主程序
    /// - Parameter open: 跳转地址
    /// - Parameter param: 跳转参数
    func jumpToMainApp(with open: Open, param: String) {
        let param = "{\"open\":\"\(open.rawValue)\", \"param\":\"\(param)\"}".base64EncodedString
        let urlStr = "qmenu://jumpTo?param=\(param ?? "")"
        guard let url = URL(string: urlStr) else {
            return
        }
        if #available(macOSApplicationExtension 10.15, *) {
            NSWorkspace.shared.openApplication(at: url, configuration: .init())
        } else {
            NSWorkspace.shared.open(url)
        }
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
        QMLoger.addLog("拷贝路径成功: \(paths)")
    }
    
    // 移动至
    @objc func moveToDirectory(_ item: NSMenuItem) {
        guard let model = QMDataManager.shared.config?.directory.first(where: { $0.id == item.tag }) else {
            QMLoger.addLog("获取常用目录配置错误: \(item.title)")
            return
        }
        guard let items = FIFinderSyncController.default().selectedItemURLs() else {
            QMLoger.addLog("移动至常用目录失败，未获取到选中路径")
            return
        }
        var basePath = model.path
        if basePath.contains("{{username}}") {
            basePath = model.path.replacingOccurrences(of: "{{username}}", with: QMUtiles.User.userName)
        }
        for item in items {
            let lastPath = item.path.lastPathComponent
            var isDirectory: ObjCBool = false
            var toPath = basePath
            if FileManager.default.fileExists(atPath: item.path, isDirectory: &isDirectory) {
                toPath = createPath(isFile: !isDirectory.boolValue, path: toPath, name: lastPath)
            }
            do {
                try FileManager.default.moveItem(atPath: item.path, toPath: toPath)
                QMLoger.addLog("已移动至: \(toPath)")
            } catch {
                QMLoger.addLog("移动至常用目录失败，\(error.localizedDescription)")
            }
        }
    }
    
    // 拷贝至
    @objc func copyToDirectory(_ item: NSMenuItem) {
        guard let model = QMDataManager.shared.config?.directory.first(where: { $0.id == item.tag }) else {
            QMLoger.addLog("获取常用目录配置错误: \(item.title)")
            return
        }
        guard let items = FIFinderSyncController.default().selectedItemURLs() else {
            QMLoger.addLog("拷贝至常用目录失败，未获取到选中路径")
            return
        }
        var basePath = model.path
        if basePath.contains("{{username}}") {
            basePath = model.path.replacingOccurrences(of: "{{username}}", with: QMUtiles.User.userName)
        }
        for item in items {
            let lastPath = item.path.lastPathComponent
            var isDirectory: ObjCBool = false
            var toPath = basePath
            if FileManager.default.fileExists(atPath: item.path, isDirectory: &isDirectory) {
                toPath = createPath(isFile: !isDirectory.boolValue, path: toPath, name: lastPath)
            }
            do {
                try FileManager.default.copyItem(atPath: item.path, toPath: toPath)
                QMLoger.addLog("已拷贝至: \(toPath)")
            } catch {
                QMLoger.addLog("拷贝至常用目录失败，\(error.localizedDescription)")
            }
        }
    }
    
    // 打开常用目录
    @objc func openDirectory(_ item: NSMenuItem) {
        guard let model = QMDataManager.shared.config?.directory.first(where: { $0.id == item.tag }) else {
            QMLoger.addLog("获取常用目录配置错误: \(item.title)")
            return
        }
        var path = model.path
        if path.contains("{{username}}") {
            path = model.path.replacingOccurrences(of: "{{username}}", with: QMUtiles.User.userName)
        }
        guard let url = URL.init(string: path) else {
            QMLoger.addLog("获取常用目录路径错误: \(item.title)")
            return
        }
        runner.launch(with: "Finder", selectURLs: [url], mode: .editor)
    }
    
    // 新建文件
    @objc func createNewFile(_ item: NSMenuItem) {
        guard let model = QMDataManager.shared.config?.file.first(where: { $0.id == item.tag }) else {
            QMLoger.addLog("获取新建文件配置错误: \(item.title)")
            return
        }
        guard let target = FIFinderSyncController.default().targetedURL() else {
            QMLoger.addLog("创建文件失败，未获取到选中路径")
            return
        }
        var path = model.path
        if model.path.count <= 0 {
            path = Bundle.main.path(forResource: model.name, ofType: model.suffix) ?? ""
        }
        let fileName = path.lastPathComponent.deletingPathExtension
        let toPath = createPath(isFile: true, path: target.path, name: fileName, suffix: model.suffix)
        do {
            try FileManager.default.copyItem(atPath: path, toPath: toPath)
            if QMDataManager.shared.config?.autoOpen ?? true {
                NSWorkspace.shared.open(URL.init(fileURLWithPath: toPath))
                QMLoger.addLog("已打开文件: \(toPath)")
            }
        } catch {
            QMLoger.addLog("创建文件失败，\(error.localizedDescription)")
        }
    }
    
    // 打开
    @objc func openItem(_ item: NSMenuItem) {
        guard let model = QMDataManager.shared.config?.launch.first(where: { $0.id == item.tag }) else {
            QMLoger.addLog("获取打开配置错误: \(item.title)")
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
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    QMLoger.addLog("删除文件失败: \(error.localizedDescription)")
                }
            } else {
                QMLoger.addLog("删除文件失败, 文件不存在: \(url.path)")
            }
        }
    }
    
    // 清理废纸篓
    @objc func cleanTrash() {
        let userName = QMUtiles.User.userName
        let path = "/Users/\(userName)/.Trash"
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory), isDirectory.boolValue else {
            QMLoger.addLog("清理废纸篓失败: 文件路径不存在 \(path)")
            jumpToMainApp(with: .auth(1), param: "{\"type\":\"\"}")
            return
        }
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: path) else {
            QMLoger.addLog("清理废纸篓无文件")
            return
        }
        for item in contents {
            let filePath = path.appending("/\(item)")
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                QMLoger.addLog("清理废纸篓文件失败: \(filePath) \(error.localizedDescription)")
            }
        }
    }
    
    @objc func addNewDirectory(_ item: NSMenuItem) {
        jumpToMainApp(with: .directory, param: "")
    }
    
    @objc func addNewFile(_ item: NSMenuItem) {
        jumpToMainApp(with: .file, param: "")
    }
}
