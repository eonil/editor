//
//  CargoService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Dispatch
import Foundation.NSFileManager
import BoltsSwift

struct CargoServiceState {
    private(set) var isRunning = false
//    var isExecutableReady = false
//    var canBuild = false
//    var canClean = false
//    var canCancel = false
    private(set) var errors = [CargoError]()
}
enum CargoError: ErrorType {
    case Unknown(String)
    case CompilerWarning(String)
    case CompilerError(String)
}
enum CargoCommand {
    /// - Parameter 0:
    ///     Destination directory will be created by `cargo new`.
    case New(NSURL)
    case Clean(NSURL)
    case Build(NSURL)
    case CancelAny
    case CancelAll
}
enum CargoServiceError: ErrorType {
    case AlreadyRunningAnotherOperation
    case BashDidExitWithNonZeroCode(exitCode: Int32)
    case BashDidHalt
}



/// You cannot run any operation while another operation is running.
/// You can try:
/// - Wait until the opration finishes.
/// - Cancel the operation first.
final class CargoService: DriverAccessible {
    private typealias Schedule = (command: CargoCommand, completion: TaskCompletionSource<()>)
    private let gcdq = dispatch_queue_create("\(CargoService.self)/GCDQ", DISPATCH_QUEUE_SERIAL)
    private var schedules = [Schedule]()

    private var state = CargoServiceState()
    private var bashCompletion = TaskCompletionSource<()>()
    private var bash: BashSubprocess?



    ////////////////////////////////////////////////////////////////
    func query() -> Task<CargoServiceState> {
        let completion = TaskCompletionSource<CargoServiceState>()
        dispatch_async(gcdq) { [weak self] in
            guard let S = self else {
                completion.cancel()
                return
            }
            completion.setResult(S.state)
        }
        return completion.task
    }
    func dispatch(command: CargoCommand) -> Task<()> {
        let completion = TaskCompletionSource<()>()
        dispatch_async(gcdq) { [weak self] in
            guard let S = self else { return }
            S.schedules.append((command, completion))
            S.run()
        }
        return completion.task
    }
    private func run() {
        guard let first = schedules.popFirst() else { return }
        do {
            (try step(first.command)).continueWithTask(Executor.Queue(gcdq), continuation: { [weak self] (task: Task<()>) -> Task<()> in
                guard let S = self else { return task }
                first.completion.trySetResult(())
                S.run()
                return task
            })
        }
        catch let error {
            reportErrorToDevelopers(error)
            first.completion.trySetError(error)
        }
        // Continues on completion.
        first.completion.task.continueWithTask(Executor.Queue(gcdq)) { [weak self] (task: Task<()>) -> Task<()> in
            guard let S = self else { return task }
            S.run()
            return task
        }
    }
    private func step(command: CargoCommand) throws -> Task<()> {
        func getDestinationDirectoryPathFrom(u: NSURL) -> String {
            assert(u.fileURL)
            guard let u1 = u.standardizedURL?.absoluteURL else { return "" }
            guard let path = u1.path else { return "" }
            return path
        }
        func getChangeDirectoryCommandTo(u: NSURL) -> String {
            assert(u.fileURL)
            return "cd " + getDestinationDirectoryPathFrom(u)
        }
        switch command {
        case .New(let u):
            assert(u.fileURL)
            let p = getDestinationDirectoryPathFrom(u)
            return try runBashSession(["cargo new " + p])

        case .Build(let u):
            assert(u.fileURL)
            let cd = getChangeDirectoryCommandTo(u)
            debugLog(cd)
            return try runBashSession([cd, "pwd", "cargo build"])

        case .Clean(let u):
            assert(u.fileURL)
            let cd = getChangeDirectoryCommandTo(u)
            return try runBashSession([cd, "cargo clean"])

        case .CancelAny:
            MARK_unimplemented()

        case .CancelAll:
            MARK_unimplemented()
        }
    }

    private func runBashSession(commands: [String]) throws -> Task<()> {
        guard bash == nil else { throw CargoServiceError.AlreadyRunningAnotherOperation }

        state.errors = []
        let newBash = try BashSubprocess()
        newBash.onEvent = { [weak self] in self?.process($0) }
        for command in commands {
            try newBash.runCommand(command)
        }
        try newBash.runCommand("exit 0;")
        bash = newBash
        return bashCompletion.task
    }
    private func process(event: BashSubprocessEvent) {
        switch event {
        case .StandardOutputDidPrintLine(let line):
            pushStandardOutputLine(line)

        case .StandardErrorDidPrintLine(let line):
            pushStandardErrorLine(line)

        case .DidExitGracefully(let exitCode):
            switch exitCode {
            case 0:
                setNormalExit()
                bashCompletion.trySetResult(())
            default:
                setAbnormalExit()
                bashCompletion.trySetError(CargoServiceError.BashDidExitWithNonZeroCode(exitCode: exitCode))
            }
            bash = nil
            bashCompletion = TaskCompletionSource()

        case .DidHaltAbnormally:
            setAbnormalExit()
            bashCompletion.trySetError(CargoServiceError.BashDidHalt)
            bash = nil
            bashCompletion = TaskCompletionSource()
        }
    }
    private func pushStandardOutputLine(line: String) {
        print(line)
    }
    private func pushStandardErrorLine(line: String) {
        guard line != "" else { return }
        state.errors.append(.Unknown(line))
    }
    private func setNormalExit() {
        state.isRunning = false
    }
    private func setAbnormalExit() {
        state.isRunning = false
    }
    private func cancelAnyOperation() {
        bash?.kill()
        bash = nil
    }

    private func apply(@noescape transaction: ()->()) {
        transaction()
        driver.notify(Notification.Cargo(CargoNotification.Step(state)))
    }
}

