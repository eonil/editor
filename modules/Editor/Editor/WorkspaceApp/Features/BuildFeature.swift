//
//  BuildFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilToolbox

final class BuildFeature: WorkspaceFeatureComponent {
    let changes = Relay<[Change]>()
    private(set) var state = State()
    private let loop = ReactiveLoop()
    private let watch = Relay<()>()
    private var project = ProjectFeature.State()
    private var cmdq = [Command]()
    private var exec: CargoProcess2?

    init() {
        watch += loop
        loop.step = { [weak self] in self?.step() }
    }
    private func step() {
        if let exec = exec {
            state.session.logs.reports.append(contentsOf: exec.logs.reports)
            state.session.logs.issues.append(contentsOf: exec.logs.issues)
            for r in exec.logs.reports {
                switch r {
                case .stdout(let m):
                    state.session.prefilteredLogs.cargoMessageReports.append(m)
                default:
                    break
                }
            }
            exec.clear()
            changes.cast([.session(.logs)])
        }
        if exec?.state == .complete {
            exec = nil
//            changes.cast([.phase])
        }

        guard exec == nil else { return } // Wait until done.
        while let cmd = cmdq.removeFirstIfAvailable() {
            switch cmd {
            case .cleanAll:
                guard let loc = project.location else { MARK_unimplemented() }
                state.session.id = .init()
                changes.cast([.session(.id)])
                let ps = CargoProcess2.Parameters(
                    location: loc,
                    command: .clean)
                exec = services.cargo.spawn(ps)

            case .cleanTarget(let t):
                MARK_unimplemented()

            case .build:
                guard let loc = project.location else { MARK_unimplemented() }
                state.session.id = .init()
                changes.cast([.session(.id)])
                let ps = CargoProcess2.Parameters(
                    location: loc,
                    command: .build)
                let proc = services.cargo.spawn(ps)
                loop.signal()
                proc.signal += watch
                exec = proc

            case .buildTarget(let t):
                MARK_unimplemented()

            case .cancel:
                MARK_unimplemented()
            }
        }
    }
    func process(_ command: Command) -> [WorkspaceCommand] {
        cmdq.append(command)
        loop.signal()
        return []
    }
    func setProjectState(_ newProjectState: ProjectFeature.State) {
        project = newProjectState
        loop.signal()
    }
}
extension BuildFeature {
    struct State {
        var phase = Phase.idle
        var session = Session()
        
        enum Phase {
            case idle
            case running
        }
        struct Session {
            var id = ID()
            var logs = Logs()
            ///
            /// Redundant subset filtered of `logs` with various conditions
            /// for performance. Appending is synced with `log`, but removing
            /// is not synced. It can be earlier of later.
            ///
            var prefilteredLogs = PrefilteredLogs()
        }
        struct ID: Equatable {
            private let oid = ObjectAddressID()
            static func == (_ a: ID, _ b: ID) -> Bool {
                return a.oid == b.oid
            }
        }
        struct Logs {
            var reports = Series<Report>()
            var issues = Series<Issue>()
        }
        struct PrefilteredLogs {
            var cargoMessageReports = Series<CargoDTO.Message>()
        }
    }
    enum Command {
        case build
        case buildTarget(Target)
        case cleanAll
        case cleanTarget(Target)
        case cancel
    }
    typealias Report = CargoProcess2.Report
    typealias Issue = CargoProcess2.Issue

    enum Change {
        case phase
        case session(Session)

        enum Session {
            ///
            /// `session.id` has been changed.
            /// This means a new session has been started.
            ///
            case id
            case logs
        }
    }
}
