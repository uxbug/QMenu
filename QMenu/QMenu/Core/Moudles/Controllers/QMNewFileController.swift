//
//  QMNewFileController.swift
//  QMenu
//
//  Created by password 1234 on 9/2/21.
//

import Cocoa

class QMNewFileController: QMBaseController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var autoOpenButton: NSButton!
    fileprivate var dataSource: [QMFileModel] = QMDataManager.shared.config?.file ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
}

fileprivate extension QMNewFileController {
    func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.enclosingScrollView?.contentInsets = NSEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.enclosingScrollView?.borderType = .noBorder
        tableView.enclosingScrollView?.verticalScrollElasticity = .none
        tableView.enclosingScrollView?.horizontalScrollElasticity = .none
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        let panel = NSOpenPanel.init()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.begin { [weak self] response in
            switch response {
            case .OK:
                guard let path = panel.url?.path else {
                    return
                }
                QMDataManager.shared.addNewFile(path)
                self?.dataSource = QMDataManager.shared.config?.file ?? []
                self?.tableView.reloadData()
            default:
                break
            }
        }
    }
    
    @IBAction func onClickRemove(_ sender: Any) {
        let row = tableView.selectedRow
        let model = dataSource[row]
        QMDataManager.shared.removeFile(model)
        dataSource = QMDataManager.shared.config?.file ?? []
        tableView.reloadData()
    }
}

extension QMNewFileController: NSTableViewDelegate, NSTableViewDataSource {
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
            var path = model.path
            if model.path.count <= 0, model.name.count > 0 {
                path = Bundle.main.path(forResource: model.name, ofType: model.suffix) ?? ""
            }
            cell?.iconView.image = NSWorkspace.shared.icon(forFile: path)
            return cell
        } else if tableColumn == tableView.tableColumns[2] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.name.identifier"), owner: nil) as? QMTextCellView
            cell?.textLabel.stringValue = model.title
            return cell
        } else if tableColumn == tableView.tableColumns[3] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feature.desc.identifier"), owner: nil) as? QMTextCellView
            cell?.textLabel.stringValue = model.suffix
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = QMTableRowView.init()
        return rowView
    }
}

extension QMNewFileController: QMOpenCellViewDelegate {
    func openCellView(_ view: QMOpenCellView, didClickBox state: NSControl.StateValue) {
        let row = tableView.row(for: view)
        let model = dataSource[row]
        QMDataManager.shared.updateNewFileState(model, state: state)
    }
}
