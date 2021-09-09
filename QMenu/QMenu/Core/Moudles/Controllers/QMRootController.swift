//
//  QMRootController.swift
//  QMenu
//
//  Created by password 1234 on 8/19/21.
//

import Cocoa

class QMRootController: QMBaseController {
    
    @IBOutlet weak var leftView: NSView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var clipView: NSClipView!
    @IBOutlet weak var collectionView: NSCollectionView!
    fileprivate lazy var tabController: QMTabViewController = {
        let controller = QMTabViewController.init()
        controller.addChilds([
            QMFeatureController(),
            QMOpenController(),
            QMDirectoryController(),
            QMNewFileController(),
            QMDescController(),
            QMAboutController()
        ])
        return controller
    }()
    fileprivate var dataSource: [String] = [
        "功能列表",
        "打开...",
        "常用目录",
        "新建文件",
        "使用说明",
        "关于我们"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
}

extension QMRootController {
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
        collectionView.selectItems(at: [IndexPath(item: 0, section: 0)], scrollPosition: .bottom)
    }
}

extension QMRootController: NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init("QMMenuItem"), for: indexPath) as! QMMenuItem
        item.textLabel.stringValue = dataSource[indexPath.item]
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
        collectionView.visibleItems().forEach { i in
            i.isSelected = item == i
        }
        tabController.selectedIndex = collectionView.visibleItems().firstIndex(of: item) ?? 0
    }
}
