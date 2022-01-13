//
//  QMLogController.swift
//  QMenu
//
//  Created by password 1234 on 9/6/21.
//

import Cocoa

class QMLogController: QMBaseController {

    @IBOutlet weak var lineView: NSView!
    @IBOutlet weak var splitView: NSSplitView!
    @IBOutlet weak var listView: NSCollectionView!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var cleanButton: NSButton!
    
    fileprivate var logs: [String] = []
    fileprivate var selectIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
}

fileprivate extension QMLogController {
    func makeUI() {
        listView.enclosingScrollView?.borderType = .noBorder
        view.backgroundColor = .white
        lineView.backgroundColor = NSColor.init(hex: 0xF5F4F4)
        splitView.setHoldingPriority(.windowSizeStayPut, forSubviewAt: 0)
        listView.register(QMLogItem.self, forItemWithIdentifier: .init("QMLogItem"))
        listView.delegate = self
        listView.dataSource = self
        textView.textContainerInset = NSSize.init(width: 10, height: 10)
        logs = QMLoger.logs
        let indexPath = IndexPath.init(item: 0, section: 0)
        if logs.count > 0, let first = listView.item(at: indexPath) as? QMLogItem {
            listView.selectItems(at: [indexPath], scrollPosition: .bottom)
            logItem(first, didSelectAt: true)
            cleanButton.isEnabled = true
        } else {
            cleanButton.isEnabled = false
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        dismiss(nil)
    }
    
    @IBAction func onClickClean(_ sender: Any) {
        let log = logs[selectIndex]
        QMLoger.cleanLog(with: log)
        logs = QMLoger.logs
        listView.reloadData()
        selectIndex = 0
        textView.string = ""
        if logs.count > 0 {
            listView.selectItems(at: [IndexPath.init(item: 0, section: 0)], scrollPosition: .bottom)
            cleanButton.isEnabled = true
        } else {
            cleanButton.isEnabled = false
        }
    }
    
}

extension QMLogController: NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return logs.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init("QMLogItem"), for: indexPath) as! QMLogItem
        item.textLabel.stringValue = logs[indexPath.item]
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

extension QMLogController: QMLogItemDelegate {
    func logItem(_ item: QMLogItem, didSelectAt selected: Bool) {
        listView.visibleItems().forEach { i in
            i.isSelected = item == i
        }
        selectIndex = listView.indexPath(for: item)?.item ?? 0
        textView.string = QMLoger.getLog(with: item.textLabel.stringValue) ?? ""
    }
}
