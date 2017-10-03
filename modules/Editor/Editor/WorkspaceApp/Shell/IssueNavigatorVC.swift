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
        tableView?.target = self
        tableView?.action = #selector(userDidClickOnTableViewCellOrColumnHeader)
        tableView?.doubleAction = #selector(userDidDoubleClickOnTableViewCellOrColumnHeader)
    }

    private func getClickedIssue() -> CargoDTO.Message? {
        guard let features = features else { return nil }
        guard let i = tableView?.clickedRow else { return nil }
        guard i != -1 else { return nil }
        return features.build.state.session.prefilteredLogs.cargoMessageReports[i]
    }
    private func render() {
        tableView?.reloadData()
    }

    @IBOutlet private weak var tableView: NSTableView?

    @objc
    private func userDidClickOnTableViewCellOrColumnHeader() {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        guard let issue = getClickedIssue() else { return }
        features.log.process(.ADHOC_printAny(issue))
    }
    @objc
    private func userDidDoubleClickOnTableViewCellOrColumnHeader() {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        let i = tableView?.clickedRow ?? -1
        guard i >= 0 else { return }
        guard i < tableView?.numberOfRows ?? 0 else { return }
        if let m = cargoMessages?[i] {
            switch m {
            case .compilerMessage(let m):
                guard let span = m.message.spans.first else { break }
                DEBUG_log(span.file_name)
                let p = ProjectItemPath.fromUnixFilePathFromProjectRoot(span.file_name)
                let u = features.project.makeURLForFile(at: p)
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
//                m.message.children
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

