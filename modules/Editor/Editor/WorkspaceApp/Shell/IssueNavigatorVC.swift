//
//  IssueNavigatorVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit
import EonilStateSeries

final class IssueNavigatorVC: NSViewController, WorkspaceFeatureDependent {
    private let buildWatch = Relay<[BuildFeature.Change]>()

    weak var features: WorkspaceFeatures? {
        didSet {
            features?.build.changes += buildWatch
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
        tableView?.rowHeight = tableView?.frame.height ?? 1_000 // Trick to remove unwanted grid lines.
        tableView?.doubleAction = #selector(userDidDoubleClickOnTableView)
    }

    private func render() {
        tableView?.reloadData()
    }

    @IBOutlet private weak var tableView: NSTableView?

    @IBAction
    private func userDidDoubleClickOnTableView(_: NSObject) {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        let i = tableView?.clickedRow ?? -1
        guard i >= 0 else { return }
        guard i < tableView?.numberOfRows ?? 0 else { return }
        if let m = cargoMessages?[i] {
            switch m {
            case .compilerMessage(let m):
                guard let span = m.message.spans.first else { break }
                DEBUG_log(span.file_name)
                let p = ProjectFeature.Path.fromUnixFilePathFromProjectRoot(span.file_name)
                guard let u = features.project.makeFileURL(for: p) else {
                    REPORT_ignoredSignal(m)
                    break
                }
                features.process(.codeEditing(.open(u)))
            case .compilerArtifact(let m):
                REPORT_unimplementedAndContinue()
            case .buildScript(let m):
                REPORT_unimplementedAndContinue()
            }
        }
    }
}
extension IssueNavigatorVC: NSTableViewDataSource {
    private var cargoMessages: Series<CargoDTO.Message>? {
        return features?.build.state.session.prefilteredLogs.cargoMessageReports
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return cargoMessages?.count ?? 0
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let m = cargoMessages?[row] {
            // TODO: Generate proper message.
            switch m {
            case .compilerMessage(let m):
                let v = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IssueItem"), owner: self) as! IssueItemTableCellView
                v.messageTextField?.stringValue = m.message.message
                return v
            default:
                break
            }
            let v = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IssueItem"), owner: self) as! IssueItemTableCellView
            v.textField?.stringValue = "\(m)"
            return v
        }
        let v = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IssueItem"), owner: self) as! IssueItemTableCellView
        return v
    }
}
extension IssueNavigatorVC: NSTableViewDelegate {
}

