//
//  ConsoleVC.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class ConsoleVC: NSViewController, WorkspaceFeatureDependent {
    private let logChangeWatch = Relay<[LogFeature.Change]>()

    weak var features: WorkspaceFeatures? {
        didSet {
            render()
            features?.log.changes += logChangeWatch
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        logChangeWatch.delegate = { [weak self] in self?.processLogChanges($0) }
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
        let s = features?.log.state.currentBuildSession?.items.map({ "\($0)" }).joined() ?? ""
        codeTextView?.string = s 
    }
//    private func renderLogChanges(_ cs: [LogFeature.Change]) {
//        MARK_unimplemented()
//    }

    @IBOutlet private weak var codeTextView: CodeView?
}
