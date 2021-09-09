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
    
    fileprivate var items: [String] = []
    fileprivate var path: String = ""
    
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
        
        guard let bundleId = Bundle.main.bundleIdentifier else {
            return
        }
        let pluginBundleId = "com.liyb.QMenu.QMenuTarget"
        path = QMLoger.logPath().replacingOccurrences(of: bundleId, with: pluginBundleId)
        getLogFiles()
        let indexPath = IndexPath.init(item: 0, section: 0)
        if items.count > 0, let first = listView.item(at: indexPath) as? QMLogItem {
            listView.selectItems(at: [indexPath], scrollPosition: .bottom)
            logItem(first, didSelectAt: true)
        }
    }
    
    func getLogFiles() {
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: path).filter({ $0.hasSuffix("log") }).sorted(by: { $0.compare($1) == .orderedDescending })
            listView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        dismiss(nil)
    }
}

extension QMLogController: NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init("QMLogItem"), for: indexPath) as! QMLogItem
        item.textLabel.stringValue = items[indexPath.item]
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
        let filePath = path + "/" + item.textLabel.stringValue
        if FileManager.default.fileExists(atPath: filePath) {
            let value = try? String.init(contentsOfFile: filePath, encoding: .utf8)
            textView.string = value ?? ""
        }
    }
}
