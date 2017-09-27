//
//  IssueNavigatorVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

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
        let report = reports[i]
        switch report {
        case .cargoMessage(let m):
            switch m {
            case .compilerMessage(let m):
                guard let span = m.message.spans.first else { break }
                DEBUG_log(span.file_name)
                let p = ProjectFeature.Path.fromUnixFilePathFromProjectRoot(span.file_name) 
                guard let u = features.project.makeFileURL(for: p) else {
                    REPORT_ignoredSignal(report)
                    break
                }
                features.process(.codeEditing(.open(u)))
            case .compilerArtifact(let m):
                REPORT_unimplementedAndContinue()
            case .buildScript(let m):
                REPORT_unimplementedAndContinue()
            }
        default:
            MARK_unimplemented()
        }
    }
}
extension IssueNavigatorVC: NSTableViewDataSource {
    private var reports: [BuildFeature.State.Report] {
        return features?.build.state.session.production.reports ?? []
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return reports.count
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let report = reports[row]
        // TODO: Generate proper message.
        switch report {
        case .cargoMessage(let m):
            switch m {
            case .compilerMessage(let m):
                let v = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IssueItem"), owner: self) as! IssueItemTableCellView
                v.messageTextField?.stringValue = m.message.message
                return v
            default:
                break
            }
        default:
            break
        }

        let v = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IssueItem"), owner: self) as! IssueItemTableCellView
        v.messageTextField?.stringValue = "\(report)"
        return v
    }
}
extension IssueNavigatorVC: NSTableViewDelegate {
}
