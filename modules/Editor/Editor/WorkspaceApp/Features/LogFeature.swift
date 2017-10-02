//
//  LogFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class LogFeature: ServicesDependent {
    let signal = Relay<()>()
    let changes = Relay<[Change]>()
    private(set) var state = State()

    func process(_ cmd: InternalCommand) {
        switch cmd {
        case .startSession(let kind):
            state.archivedSessions.append(state.currentSession)
            state.currentSession = Session(kind: kind, items: [])
            changes.cast([.currentSession, .archivedSessions])

        case .endSession:
            state.archivedSessions.append(state.currentSession)
            state.currentSession = Session(kind: .editing, items: [])
            changes.cast([.currentSession, .archivedSessions])

        case .setBuildState(let s):
            let items = [
                s.session.logs.reports.map(Item.cargoReport),
                s.session.logs.issues.map(Item.cargoIssue),
            ].joined()
            state.currentSession.items = Series(items)
            changes.cast([.currentSession])

        case .ADHOC_printAny(let v):
            state.currentSession.items.append(.ADHOC_any(v))
            changes.cast([.currentSession])
        }
    }
}
extension LogFeature {
    struct State {
        var currentSession = Session(kind: .editing, items: [])
        var archivedSessions = Series<Session>()
    }
    struct Session {
        var kind: SessionKind
        var items = Series<Item>()
    }
    enum SessionKind {
        case editing
        case building
        case running
    }
    enum Item {
        case cargoReport(CargoProcess2.Report)
        case cargoIssue(CargoProcess2.Issue)
        case ADHOC_any(Any)
    }
    enum InternalCommand {
        case startSession(SessionKind)
        case endSession
        case setBuildState(BuildFeature.State)
        case ADHOC_printAny(Any)
    }
    enum Change {
        case currentSession
        case archivedSessions
    }
}
