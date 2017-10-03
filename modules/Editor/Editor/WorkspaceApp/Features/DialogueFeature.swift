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
    let transaction = Relay<Void>()
    private(set) var state = State()
    private var queue = [Command]()

    func process(_ cmd: Command) -> [WorkspaceCommand] {
        queue.append(cmd)
        step()
        return []
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
                return
            case .kill(let id):
                REPORT_ignoredSignal(cmd)
            }
        }
    }
    private func stepRunning() {
        while let cmd = queue.removeFirstIfAvailable() {
            switch cmd {
            case .spawn(let content):
                queue.insert(cmd, at: 0) // Restore command.
                return
            case .kill(let id):
                guard id == state.running?.id else {
                    REPORT_ignoredSignal(cmd)
                    break
                }
                state.running = nil
            }
        }
    }


}
extension DialogueFeature {
    struct State {
        var running: (id: ID, alert: Alert)?
    }
    enum Command {
        case spawn(Alert)
        case kill(ID)
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
    enum Query {
        case selectFileURLForWorkspaceSave
        case selectFileURLForWorkspaceOpen
        case selectFileURLForNodeImport
        case selectFileURLForNodeExport
    }
    enum Warning {

    }
    enum Error {
        case ADHOC_any(String)
        case cannotSaveCurrentlyEditingCodeIntoFile
    }
}
