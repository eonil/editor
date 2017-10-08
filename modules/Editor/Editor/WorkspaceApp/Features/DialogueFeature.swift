//
//  DialogueFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/24.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilSignet
import EonilToolbox

final class DialogueFeature: WorkspaceFeatureComponent {
    let changes = Relay<[Change]>()
    private(set) var state = State()
    private var queue = [Command]()

    func process(_ cmd: Command) -> Result<Void, Void> {
        queue.append(cmd)
        step()
        return .success(Void())
    }
    private func step() {
        if state.running == nil {
            stepIdle()
        }
        else {
            stepRunning()
        }
    }
    private func stepIdle() {
        while let cmd = queue.removeFirstIfAvailable() {
            switch cmd {
            case .spawn(let content):
                let id = ID()
                state.running = (id, content)
                changes.cast([])
                return
            case .kill(_):
                REPORT_ignoredSignal(cmd)
            }
        }
    }
    private func stepRunning() {
        while let cmd = queue.removeFirstIfAvailable() {
            switch cmd {
            case .spawn(_):
                queue.insert(cmd, at: 0) // Restore command.
                changes.cast([])
                return
            case .kill(let id):
                guard id == state.running?.id else {
                    REPORT_ignoredSignal(cmd)
                    break
                }
                state.running = nil
                changes.cast([])
                return
            }
        }
    }


}
extension DialogueFeature {
    struct State {
        var running: (id: ID, alert: Alert)?
    }
    struct ID: Equatable {
        private let oid = ObjectAddressID()
        static func == (_ a: ID, _ b: ID) -> Bool {
            return a.oid == b.oid
        }
    }
    enum Alert {
        ///
        /// Just an information.
        ///
        case note(Note)
        ///
        /// Ask user for a decision.
        /// Each query defines what to do
        /// for each options.
        ///
        case query(Query)
        case warning(Warning)
        case error(Error)
    }
    enum Note {
        case DEV_any(String)
    }
    ///
    /// - Note:
    ///     Workspace-open should be handled from driver app, not in each
    ///     workspaces.
    ///
    enum Query {
        case selectFileURLForWorkspaceSave
//        case selectFileURLForWorkspaceOpen
        case selectFileURLForNodeImport
        case selectFileURLForNodeExport
    }
    enum Warning {

    }
    enum Error {
        case workspace(WorkspaceIssue)
        case ADHOC_any(String)
    }
}
extension DialogueFeature {
    enum Command {
        case spawn(Alert)
        case kill(ID)
    }
    typealias Change = Void
}
