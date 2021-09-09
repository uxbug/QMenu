//
//  QMOpenController.swift
//  QMenu
//
//  Created by password 1234 on 9/6/21.
//

import Cocoa

class QMOpenController: QMBaseController {

    @IBOutlet weak var tableView: NSTableView!
    
    fileprivate var dataSource: [QMFeatureModel] = QMDataManager.shared.config?.open ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
}

fileprivate extension QMOpenController {
    func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.enclosingScrollView?.borderType = .noBorder
        tableView.enclosingScrollView?.verticalScrollElasticity = .none
        tableView.enclosingScrollView?.horizontalScrollElasticity = .none
    }
}

extension QMOpenController: NSTableViewDelegate, NSTableViewDataSource {
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
            return cell
        } else if tableColumn == tableView.tableColumns[3] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.desc.identifier"), owner: nil) as? QMTextCellView
            cell?.textLabel.stringValue = model.desc
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let model = dataSource[row]
        guard let column = tableView.tableColumns.last else {
            return 30
        }
        let attributedStr = NSAttributedString.init(string: model.desc, attributes: [
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12)
        ])
        let size = attributedStr.boundingRect(with: NSSize.init(width: column.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        let height = max(size.height + 10, 30)
        return height
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = QMTableRowView.init()
        return rowView
    }
}

extension QMOpenController: QMOpenCellViewDelegate {
    func openCellView(_ view: QMOpenCellView, didClickBox state: NSControl.StateValue) {
        let row = tableView.row(for: view)
        let model = dataSource[row]
        QMDataManager.shared.updateOpenState(model, state: state)
    }
}
