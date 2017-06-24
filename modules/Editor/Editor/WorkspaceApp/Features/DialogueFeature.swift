//
//  DialogueFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/24.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilSignet

final class DialogueFeature {
    let transaction = Relay<Void>()
    private(set) var state = State()
    func queue(_ a: Alert) {
        state.queue.append(a)
        transaction.cast()
    }
    func killCurrent() {
        state.queue.removeFirstIfAvailable()
        transaction.cast()
    }
}
extension DialogueFeature {
    struct State {
        var queue = [Alert]()
        var current: Alert? {
            return queue.first
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

    }
}
