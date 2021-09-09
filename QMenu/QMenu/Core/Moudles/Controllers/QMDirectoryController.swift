//
//  QMDirectoryController.swift
//  QMenu
//
//  Created by password 1234 on 9/2/21.
//

import Cocoa

class QMDirectoryController: QMBaseController {

    @IBOutlet weak var tableView: NSTableView!
    fileprivate var dataSource: [QMFeatureModel] = QMDataManager.shared.config?.directory ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }

}

fileprivate extension QMDirectoryController {
    func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.enclosingScrollView?.borderType = .noBorder
        tableView.enclosingScrollView?.verticalScrollElasticity = .none
        tableView.enclosingScrollView?.horizontalScrollElasticity = .none
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        let panel = NSOpenPanel.init()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.begin { [weak self] response in
            switch response {
            case .OK:
                guard let path = panel.url?.path else {
                    return
                }
                QMDataManager.shared.addDirectory(path)
                self?.dataSource = QMDataManager.shared.config?.directory ?? []
                self?.tableView.reloadData()
            default:
                break
            }
        }
    }
    
    @IBAction func onClickRemove(_ sender: Any) {
        let row = tableView.selectedRow
        let model = dataSource[row]
        QMDataManager.shared.removeDirectory(model)
        dataSource = QMDataManager.shared.config?.directory ?? []
        tableView.reloadData()
    }
}

extension QMDirectoryController: NSTableViewDelegate, NSTableViewDataSource {
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
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.desc.identifier"), owner: nil) as? QMTextCellView
            cell?.textLabel.stringValue = model.title + "(\(model.path)"
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = QMTableRowView.init()
        return rowView
    }
}

extension QMDirectoryController: QMOpenCellViewDelegate {
    func openCellView(_ view: QMOpenCellView, didClickBox state: NSControl.StateValue) {
        let row = tableView.row(for: view)
        let model = dataSource[row]
        QMDataManager.shared.updateDirectoryState(model, state: state)
    }
}