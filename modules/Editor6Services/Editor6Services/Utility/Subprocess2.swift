//
//  Subprocess2Controller.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/18.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

enum Subprocess2Command {
    /// Writes to subprocess' stdin.
    case stdin(Data)
}
enum Subprocess2Event {
    case terminate(exitCode: Int32)
    case stdout(Data)
    case stderr(Data)
}
enum Subprocess2Phase {
    case notLaunched
    case running
    case terminated
}
struct Subprocess2State {
    var phase = Subprocess2Phase.notLaunched
}
final class Subprocess2Controller {
    typealias Delegate = ((Subprocess2Event) -> ())

    private let proc = Process()
    private var delegate = Delegate?.none
    private(set) var state = Subprocess2State()

    private let stdinPipe = Pipe()
    private let stdoutPipe = Pipe()
    private let stderrPipe = Pipe()

    init(path: String, arguments: [String]) {
        let dispatchToDelegate = { [weak self] (_ event: Subprocess2Event) in
            self?.delegate?(event)
        }
        let read = { (f: FileHandle) -> (Data) in return f.availableData }
        stdoutPipe.fileHandleForReading.readabilityHandler = { dispatchToDelegate(.stdout(read($0))) }
        stderrPipe.fileHandleForReading.readabilityHandler = { dispatchToDelegate(.stderr(read($0))) }
        proc.standardInput = stdinPipe
        proc.standardOutput = stdoutPipe
        proc.standardError = stderrPipe
        proc.launchPath = path
        proc.arguments = arguments
        proc.terminationHandler = { [weak self] _ in self?.dispatchTermination() }
    }
    deinit {
        proc.terminate()
        proc.waitUntilExit()
    }
    /// - Parameter newDelegate:
    ///     Will be called from another GCD queue.
    ///
    func delegate(to newDelegate: @escaping Delegate) {
        delegate = newDelegate
    }
    func launch() {
        proc.launch()
    }
    func dispatch(command: Subprocess2Command) {
        switch command {
        case .stdin(let data):
            stdinPipe.fileHandleForWriting.write(data)
        }
    }
    private func dispatchTermination() {
        let exitCode = proc.terminationStatus
        delegate?(.terminate(exitCode: exitCode))
    }
}

