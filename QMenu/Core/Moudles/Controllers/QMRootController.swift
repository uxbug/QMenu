//
//  QMRootController.swift
//  QMenu
//
//  Created by password 1234 on 8/19/21.
//

import Cocoa
import macOSThemeKit

class QMRootController: QMBaseController {
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var leftView: NSView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var clipView: NSClipView!
    @IBOutlet weak var collectionView: NSCollectionView!
    fileprivate lazy var tabController: QMTabViewController = {
        let controller = QMTabViewController.init()
        controller.addChilds([
            QMFeatureController(),
            QMLaunchController(),
            QMDirectoryController(),
            QMNewFileController(),
            QMSettingController(),
            QMDescController(),
            QMAboutController()
        ])
        return controller
    }()
    
    fileprivate var dataSource: [(String, TabStyle)] = [
        ("功能列表", .feature),
        ("打开...", .launch),
        ("常用目录", .directory),
        ("新建文件", .newFile),
        ("偏好配置", .setting),
        ("使用说明", .desc),
        ("关于我们", .about)
    ]
    
    var selectIndex: Int = 0 {
        didSet {
            let item = collectionView.item(at: selectIndex) as? QMMenuItem
            collectionView.visibleItems().forEach { $0.isSelected = $0 == item }
            let data = dataSource[selectIndex]
            tabController.selectedIndex = selectIndex
            view.window?.title = data.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.title = dataSource[selectIndex].0
        checkAuthorationStatus()
    }
}

private extension QMRootController {
    func makeUI() {
        addChild(tabController)
        view.addSubview(tabController.view)
        tabController.view.frame = CGRect.init(x: leftView.frame.maxX, y: 0, width: view.frame.width-leftView.frame.width, height: view.frame.height)
        scrollView.drawsBackground = false
        clipView.drawsBackground = false
        scrollView.backgroundColor = .clear
        clipView.backgroundColor = .clear
        collectionView.wantsLayer = true
        collectionView.backgroundColors = [.clear]
        collectionView.register(QMMenuItem.self, forItemWithIdentifier: .init("QMMenuItem"))
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let text = "\(QMUtiles.App.name) v\(QMUtiles.App.version)"
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.alignment = .center
        let attributedString = NSMutableAttributedString.init(string: text, attributes: [
            NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: ThemeColor.menuNormalTextColor,
            NSAttributedString.Key.paragraphStyle: paragraph,
        ])
        let range = (text as NSString).range(of: "v\(QMUtiles.App.version)")
        attributedString.addAttributes([NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12)], range: range)
        nameLabel.attributedStringValue = attributedString
    }
    
    func checkAuthorationStatus() {
        // 检测扩展启用状态和完全磁盘访问权限
        if (!isExtensionEnabled || QMUtiles.Authoration.fullDiskStatus != .authorized), selectIndex != 4 {
            selectIndex = 4
            collectionView.selectItems(at: [IndexPath(item: selectIndex, section: 0)], scrollPosition: .bottom)
        }
    }
}

extension QMRootController: NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init("QMMenuItem"), for: indexPath) as! QMMenuItem
        item.data = dataSource[indexPath.item]
        item.delegate = self
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return .init(width: collectionView.frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension QMRootController: QMMenuItemDelegate {
    func menuItem(_ item: QMMenuItem, didSelectAt selected: Bool) {
        collectionView.visibleItems().forEach { $0.isSelected = $0 == item }
        tabController.selectedIndex = collectionView.indexPath(for: item)?.item ?? 0
        view.window?.title = item.data.0
    }
}
