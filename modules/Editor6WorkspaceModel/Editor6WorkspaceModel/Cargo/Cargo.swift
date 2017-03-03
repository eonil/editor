//
//  Cargo.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/17.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox
import EonilJSON

struct CargoState {
    var phase = CargoPhase.idle
    var issues = [CargoIssue]()
    var errors = [CargoError]()
}
public enum CargoCommand {
    case `init`(URL)
    case build(URL)
    case clean(URL)
}
public enum CargoPhase {
    case idle
    case busy
}
enum CargoIssue {
    case ADHOC_dtoFromCompiler(CargoDTO.FromCompiler)
    case ADHOC_unknown(JSONValue)
    case ADHOC_unknownUndecodable(String)
}
enum CargoEvent {
    case phase
    ///
    /// Problems of user content (source code and etc.).
    ///
    case issue(CargoIssue)
    /// 
    /// Errors of Cargo tool itself.
    /// These are not from user content (source code and etc.).
    ///
    case error(CargoError)
}
enum CargoError: Error {
    case cannotFindParentDirectory
    case cannotFindDirectory
    case nonZeroExit(code: Int32)
}

///
/// Cargo commands will be executed serially in a `Cargo` instance.
///
/// - TODO: No error check for `cargo init` and `cargo clean` for now.
///     Implement it.
///
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
        switch command {
        case .init(let u):
            queueBashExecution(commandLines: [
                "set -e",
                "cd \(u.path)",
                "cargo init --bin",
                "exit",
                ])
        case .build(let u):
            queueBashExecution(commandLines: [
                "set -e",
                "cd \(u.path)",
                "cargo build --message-format=json",
                "exit",
                ])
        case .clean(let u):
            queueBashExecution(commandLines: [
                "set -e",
                "cd \(u.path)",
                "cargo clean",
                "exit",
                ])
        }
    }
    func halt() {
        haltImpl()
    }

    ///
    /// - Parameter commandLines:
    ///     Array of strings without ending `\n` characters.
    ///     These strings will be written to Bash process'es
    ///     std-in.
    ///
    private func queueBashExecution(commandLines: [String]) {
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
            debugLog(withAddressOf: bashsp, message: "BASH phase = \(bashsp.phase)")
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
        let s = lines.joined(separator: "\n")
        let i = makeCargoIssue(from: s)
        print(i)
        state.issues.append(i)
    }
    func process(stderr lines: [String]) {
        print(lines)
    }
}

private func makeCargoIssue(from s: String) -> CargoIssue {
    let d = s.data(using: .utf8) ?? Data()
    guard let j = try? JSON.deserialize(d) else { return .ADHOC_unknownUndecodable(s) }
    return (try? makeCargoIssue(from: j)) ?? .ADHOC_unknownUndecodable(s)
}
private func makeCargoIssue(from json: JSONValue) throws -> CargoIssue {
    switch try? json.ed6_getField("reason") as String {
    case .none:
        return .ADHOC_unknown(json)
    case .some(let c):
        switch c {
        case "compiler-message":
            return .ADHOC_dtoFromCompiler(try CargoDTO.FromCompiler(json: json))
        default:
            return .ADHOC_unknown(json)
        }
    }
}
