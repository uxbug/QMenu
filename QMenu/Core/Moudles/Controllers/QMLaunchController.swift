//
//  QMLaunchController.swift
//  QMenu
//
//  Created by password 1234 on 9/6/21.
//

import Cocoa

class QMLaunchController: QMBaseController {

    @IBOutlet weak var tableView: NSTableView!
    
    fileprivate var dataSource: [QMLaunchModel] = QMDataManager.shared.config?.launch ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
}

// MARK: Private Method
fileprivate extension QMLaunchController {
    func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.enclosingScrollView?.contentInsets = NSEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.enclosingScrollView?.borderType = .noBorder
        tableView.enclosingScrollView?.verticalScrollElasticity = .none
        tableView.enclosingScrollView?.horizontalScrollElasticity = .none
    }
}

// MARK: NSTableViewDelegate, NSTableViewDataSource
extension QMLaunchController: NSTableViewDelegate, NSTableViewDataSource {
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
            var image: NSImage?
            if model.iconPath.count > 0 {
                image = NSImage.init(contentsOfFile: model.iconPath)
            } else {
                image = NSImage.init(named: model.icon)
            }
            cell?.iconView.image = image
            return cell
        } else if tableColumn == tableView.tableColumns[2] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.name.identifier"), owner: nil) as? QMTextCellView
            cell?.textLabel.stringValue = model.title
            cell?.textLabel.toolTip = model.title
            cell?.textLabel.allowsExpansionToolTips = true
            cell?.textLabel.isEditable = true
            cell?.delegate = self
            return cell
        } else if tableColumn == tableView.tableColumns[3] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.desc.identifier"), owner: nil) as? QMTextCellView
            cell?.textLabel.stringValue = model.desc
            cell?.textLabel.toolTip = model.desc
            cell?.textLabel.allowsExpansionToolTips = true
            cell?.textLabel.isEditable = false
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = QMTableRowView.init()
        return rowView
    }
}

// MARK: QMOpenCellViewDelegate
extension QMLaunchController: QMOpenCellViewDelegate {
    func openCellView(_ view: QMOpenCellView, didClickBox state: NSControl.StateValue) {
        let row = tableView.row(for: view)
        let model = dataSource[row]
        QMDataManager.shared.updateLaunchState(model, state: state)
    }
}

// MARK: QMTextCellViewDelegate
extension QMLaunchController: QMTextCellViewDelegate {
    func textCellView(_ cellView: QMTextCellView, didEndEditingAt text: String) {
        let row = tableView.row(for: cellView)
        let model = dataSource[row]
        QMDataManager.shared.updateLaunchTitle(model, title: text)
    }
}
