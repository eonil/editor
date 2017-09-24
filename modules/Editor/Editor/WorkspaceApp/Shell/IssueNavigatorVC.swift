//
//  IssueNavigatorVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class IssueNavigatorVC: NSViewController, WorkspaceFeatureDependent {
    private let buildWatch = Relay<()>()
    weak var features: WorkspaceFeatures? {
        didSet {
            features?.build.change += buildWatch
            render()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildWatch.delegate = { [weak self] _ in self?.render() }
        render()
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        tableView?.sizeLastColumnToFit()
        tableView?.rowHeight = tableView?.frame.height ?? 1_000
    }

    private func render() {
        tableView?.reloadData()
    }

    @IBOutlet private weak var tableView: NSTableView?
}
extension IssueNavigatorVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return features?.build.production.reports.count ?? 0
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 60
    }
//    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
//        return IssueTableRowView()
//    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let features = features else { return nil }
        let report = features.build.production.reports[row]
        // TODO: Generate proper message.
        switch report {
        case .cargoMessage(let m):
            switch m {
            case .compilerMessage(let m):
                let v = tableView.make(withIdentifier: "CompilerMessageItem", owner: self) as! IssueTableItemCellView
                v.messageLabel?.stringValue = m.message.message
                var fns = [String]()
                for span in m.message.spans {
                    let fn = span.file_name
                    if fns.contains(fn) == false {
                        fns.append(fn)
                    }
                }
                let loc = fns.joined(separator: ", ")
                v.locationLabel?.stringValue = loc
                return v
            default:
                break
            }
        default:
            break
        }
        let v = tableView.make(withIdentifier: "UnknownItem", owner: self) as! NSTableCellView
        v.textField?.stringValue = "\(report)"
        return v
    }
}
extension IssueNavigatorVC: NSTableViewDelegate {
}
