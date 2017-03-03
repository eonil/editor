//
//  Cargo.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/17.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

struct CargoState {
    var phase = CargoPhase.idle
    var issues = [CargoIssue]()
    var errors = [CargoError]()
}
enum CargoCommand {
    case `init`(URL)
    case build(URL)
    case clean(URL)
}
enum CargoPhase {
    case idle
    case busy
}
struct CargoIssue {
//    var sourcePath = ""
//    var line = Int?.none
//    var column = Int?.none
    var description = ""
}
enum CargoEvent {
    case phase
    case issue(CargoIssue)
    case error(CargoError)
}
enum CargoError: Error {
    case cannotFindParentDirectory
    case cannotFindDirectory
    case nonZeroExit(code: Int32)
}

/// Cargo commands will be executed serially in a `Cargo` instance.
public final class CargoModel {
    ///
    /// All command executions in one cargo model 
    /// shares one flow to make them executed 
    /// serially.
    ///
    private let flow = Flow2<CargoModel>()
    private(set) var state = CargoState()
    private var delegate = ((CargoEvent) -> ())?.none
    ///
    /// All of each command executions defines
    /// their own halt implementations. Therefore 
    /// this changes as new command get
    /// executed.
    ///
    private var haltImpl = {}



    internal init() {
        flow.context = self
    }

    func delegate(to newDelegate: @escaping (CargoEvent) -> ()) {
        delegate = newDelegate
    }
    func queue(_ command: CargoCommand) {
        process(command)
    }
    func halt() {
        haltImpl()
    }
    private func process(_ command: CargoCommand) {
        switch command {
        case .init(let u):
            runBash(commandLines: [
                "set -e",
                "cd \(u.path)",
                "cargo init",
                "exit",
                ])
        case .build(let u):
            runBash(commandLines: [
                "set -e",
                "cd \(u.path)",
                "cargo build",
                "exit",
                ])
        case .clean(let u):
            runBash(commandLines: [
                "set -e",
                "cd \(u.path)",
                "cargo clean",
                "exit",
                ])
        }
    }
    ///
    /// - Parameter commandLines:
    ///     Array of strings without ending `\n` characters.
    ///     These strings will be written to Bash process'es
    ///     std-in.
    ///
    private func runBash(commandLines: [String]) {
        let bashsp = ADHOC_TextLineBashSubprocess()
        bashsp.delegate { [weak self] in
            guard let ss = self else { return }
            ss.process(bash: $0)
            ss.flow.signal()
        }
        flow.execute { ss in
            ss.reinstallHaltImpl(with: bashsp)
            ss.state.phase = .busy
            bashsp.queue(.launch)
            bashsp.queue(.stdin(lines: commandLines))
        }
        flow.wait { f -> Bool in
            return bashsp.phase != .terminated
        }
        flow.execute { ss in
            ss.reinstallHaltImpl(with: nil)
            ss.state.phase = .idle
        }
    }
    private func reinstallHaltImpl(with bashsp: ADHOC_TextLineBashSubprocess?) {
        haltImpl = { [weak bashsp] in
            /// https://en.wikipedia.org/wiki/Control-C
            /// https://en.wikipedia.org/wiki/End-of-Text_character
            bashsp?.queue(.stdin(lines: ["\u{0003}"]))
        }
    }
    func process(bash e: ADHOC_TextLineBashSubprocess.Event) {
        switch e {
        case .stdout(let lines):
            process(stdout: lines)
        case .stderr(let lines):
            process(stderr: lines)
        case .term(let exitCode):
            if exitCode != 0 {
                let err = CargoError.nonZeroExit(code: exitCode)
                state.errors.append(err)
                delegate?(.error(err))
            }
            state.phase = .idle
            delegate?(.phase)
        }
    }
    func process(stdout lines: [String]) {

    }
    func process(stderr lines: [String]) {

    }
}

private extension CargoState {

}
