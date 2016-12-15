//
//  Subprocess1Controller.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/18.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

enum Subprocess1Action {
    case terminate(exitCode: Int32)
    case stdout(Data)
    case stderr(Data)
}
enum Subprocess1Phase {
    case notLaunched
    case running
    case terminated
}
struct Subprocess1State {
    var phase = Subprocess1Phase.notLaunched
}
final class Subprocess1Controller {
    typealias Delegate = ((_ sender: Subprocess1Controller, _ action: Subprocess1Action) -> ())
    private let proc = Process()
    private var delegate = Delegate?.none
    private(set) var state = Subprocess1State()

    private let writeGCDQ: DispatchQueue
    private let stdinPipe = Pipe()

    private let readGCDQ: DispatchQueue
    private let stdoutPipe = Pipe()
    private let stderrPipe = Pipe()

    init(path: String, arguments: [String], ioQueuePair: IOQueuePair = .main) {
        writeGCDQ = ioQueuePair.outgoing
        readGCDQ = ioQueuePair.incoming
        let dispatchToDelegate = { [weak self] (action: Subprocess1Action) in
            self?.readGCDQ.async { [weak self] in
                guard let s = self else { return }
                self?.delegate?(s, action)
            }
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
    /// Writes to subprocess' stdin.
    func dispatch(data: Data) {
        writeGCDQ.async { [weak self] in
            self?.stdinPipe.fileHandleForWriting.write(data)
        }
    }
    private func dispatchTermination() {
        let exitCode = proc.terminationStatus
        delegate?(self, .terminate(exitCode: exitCode))
    }
}

