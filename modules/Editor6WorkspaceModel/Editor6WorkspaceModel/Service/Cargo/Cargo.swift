//
//  Cargo.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/17.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilFlow4

struct CargoState {
    var location = URL?.none
    var phase = CargoPhase.ready
    var issues = [CargoIssue]()
    var errors = [CargoError]()
}
enum CargoCommand {
    case new(URL)
    case build(URL)
    case clean(URL)
    case halt
}
enum CargoPhase {
    case ready
    case running
    case exit
}
struct CargoIssue {
//    var sourcePath = ""
//    var line = Int?.none
//    var column = Int?.none
    var description = ""
}
enum CargoNotification {
    case issue(CargoIssue)
    case error(CargoError)
    case exit(code: Int32)
}
enum CargoError: Error {
    case cannotFindParentDirectory
    case cannotFindDirectory
    case nonZeroExit(code: Int32)
}

/// Cargo commands will be executed serially in a `Cargo` instance.
public final class Cargo {
    private var delegate = ((CargoNotification) -> ())?.none
    private(set) var state = CargoState()
    private var commandQueue = TrackableCommandQueue<CargoCommand>()
    private var bash = Bash4()

    internal init() {}
    func delegate(to newDelegate: @escaping (CargoNotification) -> ()) {
        delegate = newDelegate
    }
    func queue(_ command: CargoCommand) {
        commandQueue.queue(command: command) { [weak self] in self?.process($0) }
        continueIfPossible()
    }
    private func continueIfPossible() {
        guard commandQueue.count > 0 else { return }
        guard .running != state.phase else { return }
        commandQueue.processOne()
    }
    private func process(_ command: CargoCommand) {
        switch command {
        case .new(let location):
            new(at: location)
        case .build(let location):
            build(at: location)
        case .clean(let location):
            clean(at: location)
        case .halt:
            halt()
        }
    }
    private func new(at url: URL) -> Future<()> {
        assert(bash.isRunning == false)
        let parentURL = url.deletingLastPathComponent()
        let name = url.lastPathComponent
        let parentPath = parentURL.path
        guard FileManager.default.fileExists(atPath: parentPath) else {
            let e = CargoError.cannotFindParentDirectory
            state.errors.append(e)
            return Future(error: e)
        }
        let cmds = [
            "cd \(parentPath)",
            "cargo new \(name)",
        ]
        return Bash4.run(commands: cmds)
    }
    private func build(at url: URL) {
        assert(bash.isRunning == false)
        guard FileManager.default.fileExists(atPath: url.path) else {
            state.errors.append(.cannotFindDirectory)
            return
        }
        let cmds = [
            "cd \(url)",
            "cargo build",
        ]
        remakeBash()
        bash.dispatch(cmds)
    }
    private func clean(at url: URL) {
        assert(bash.isRunning == false)
        guard FileManager.default.fileExists(atPath: url.path) else {
            state.errors.append(.cannotFindDirectory)
            return
        }
        let cmds = [
            "cd \(url)",
            "cargo clean",
            ]
        remakeBash()
        bash.dispatch(cmds)
    }
    private func halt() {
        /// https://en.wikipedia.org/wiki/Control-C
        /// https://en.wikipedia.org/wiki/End-of-Text_character
        bash.dispatch(["\u{0003}"])
    }
    private func process(_ action: Bash4Event) {
        switch action {
        case .output(let lines):
            lines.forEach(processBashSTDOUT)
        case .error(let lines):
            lines.forEach(processBashSTDERR)
        case .terminate(let exitCode):
            state.phase = .exit
            delegate?(.exit(code: exitCode))
        }
    }
    private func processBashSTDOUT(line: String) {

    }
    private func processBashSTDERR(line: String) {
        if let s = line.toCargoIssueIfPossible() {
            delegate?(.issue(s))
        }
    }
    private func remakeBash() {
        bash = Bash4(ioQueuePair: .makeDualSerialBackground())
        bash.delegate { [weak self] in self?.process($1) }
    }
}

private extension String {
    func toCargoIssueIfPossible() -> CargoIssue? {
        return CargoIssue(description: self)
    }
}
