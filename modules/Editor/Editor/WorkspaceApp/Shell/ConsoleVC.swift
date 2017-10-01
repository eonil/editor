//
//  ConsoleVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class ConsoleVC: NSViewController, WorkspaceFeatureDependent {
    private let buildChangeWatch = Relay<[BuildFeature.Change]>()
    private let logChangeWatch = Relay<[LogFeature.Change]>()
    private var filteredStdErrReports = FilteredIncrementalList<BuildFeature.Report>({
        switch $0 {
        case .stdout:   return false
        case .stderr:   return true
        }
    })

    weak var features: WorkspaceFeatures? {
        didSet {
            render()
            features?.build.changes += buildChangeWatch
            features?.log.changes += logChangeWatch
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        buildChangeWatch.delegate = { [weak self] in self?.processBuildChanges($0) }
        logChangeWatch.delegate = { [weak self] in self?.processLogChanges($0) }
    }
    private func processBuildChanges(_ cs: [BuildFeature.Change]) {
        for c in cs {
            switch c {
            case .phase:
                break
            case .session(let field):
                switch field {
                case .id:
                    break
                case .logs(let field):
                    switch field {
                    case .reports(let t):
                        filteredStdErrReports.apply(idempotentTransition: t)
                    case .issues(_):
                        break
                    }
                    render()
                }
            }
        }
    }
    private func processLogChanges(_ cs: [LogFeature.Change]) {
        DEBUG_log("Receive log change: \(cs)")
        for c in cs {
            switch c {
            case .currentBuildSession:
                render()
                // TODO: Needs optimization.
            case .archivedBuildSessions:
                REPORT_unimplementedAndContinue()
            }
        }
    }
    private func render() {
        func toConsoleLogLine(_ r: BuildFeature.Report) -> String? {
            switch r {
            case .stdout(_):        return nil
            case .stderr(let s):    return s
            }
        }
        let lines = features?.build.state.session.logs.reports.flatMap(toConsoleLogLine) ?? []
        codeTextView?.string = lines.joined(separator: "\n")
        codeTextView?.isEnabled = true
    }
//    private func renderLogChanges(_ cs: [LogFeature.Change]) {
//        MARK_unimplemented()
//    }

    @IBOutlet private weak var codeTextView: CodeView?
}
