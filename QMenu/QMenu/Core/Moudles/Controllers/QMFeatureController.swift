//
//  QMFeatureController.swift
//  QMenu
//
//  Created by password 1234 on 8/31/21.
//

import Cocoa

class QMFeatureController: QMBaseController {

    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    
    fileprivate var dataSource: [QMFeatureModel] = QMDataManager.shared.config?.feature ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
}

fileprivate extension QMFeatureController {
    func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.enclosingScrollView?.contentInsets = NSEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.enclosingScrollView?.borderType = .noBorder
        scrollView.verticalScrollElasticity = .none
        scrollView.horizontalScrollElasticity = .none
    }
}

extension QMFeatureController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let model = dataSource[row]
        if tableColumn == tableView.tableColumns[0] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.open.identifier"), owner: nil) as? QMOpenCellView
            cell?.box.state = model.state
            cell?.delegate = self
            return cell
        } else if tableColumn == tableView.tableColumns[1] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.icon.identifier"), owner: nil) as? QMIconCellView
            cell?.iconView.image = NSImage.init(named: model.icon)
            return cell
        } else if tableColumn == tableView.tableColumns[2] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.name.identifier"), owner: nil) as? QMTextCellView
            cell?.textLabel.stringValue = model.title
            cell?.textLabel.toolTip = model.title
            cell?.textLabel.allowsExpansionToolTips = true
            return cell
        } else if tableColumn == tableView.tableColumns[3] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.desc.identifier"), owner: nil) as? QMTextCellView
            cell?.textLabel.stringValue = model.desc
            cell?.textLabel.toolTip = model.desc
            cell?.textLabel.allowsExpansionToolTips = true
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = QMTableRowView.init()
        return rowView
    }
}

extension QMFeatureController: QMOpenCellViewDelegate {
    func openCellView(_ view: QMOpenCellView, didClickBox state: NSControl.StateValue) {
        let row = tableView.row(for: view)
        let model = dataSource[row]
        QMDataManager.shared.updateFeatureState(model, state: state)
    }
}
