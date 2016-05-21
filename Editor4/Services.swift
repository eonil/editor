//
//  Service.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

import BoltsSwift

typealias ADHOC_UndefinedType = ()

struct Services {
    let racer = RacerService()
    let cargo = CargoService()
    let lldb = LLDBService()
}
extension Services: DriverAccessible {
    func apply(action: Action) {
        
    }
}



final class RacerService {
    private init() {
    }
    func queryCandidatesAt(fileURL: NSURL, line: Int, column: Int) -> Task<ADHOC_UndefinedType> {
        MARK_unimplemented()
    }
    func cancelQuery() {
    }
}





struct CargoServiceState {
    var isRunning = false
//    var isExecutableReady = false
//    var canBuild = false
//    var canClean = false
//    var canCancel = false
    var errors = [CargoError]()
}
enum CargoError: ErrorType {
    case Unknown(String)
    case CompilerWarning(String)
    case CompilerError(String)
}
enum CargoOperation {
    /// - Parameter 0:
    ///     Destination directory will be created by `cargo new`.
    case New(NSURL)
    case Clean
    case Build
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
final class CargoService {
    private init() {
    }

    ////////////////////////////////////////////////////////////////
    private(set) var state = CargoServiceState() {
        didSet { onDidSetState?() }
    }
    var onDidSetState: (()->())?
    private func updateState() -> Task<()> {
        MARK_unimplemented()
    }

    ////////////////////////////////////////////////////////////////
    private var compl = TaskCompletionSource<()>()
    private var bash: BashSubprocess?
    private func runBashSession(command: String) throws -> Task<()> {
        guard bash == nil else { throw CargoServiceError.AlreadyRunningAnotherOperation }

        state.errors = []
        let newBash = try BashSubprocess()
        newBash.onEvent = { [weak self] in self?.process($0) }
        try newBash.runCommand(command)
        try newBash.runCommand("exit 0;")
        bash = newBash
        return compl.task
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
                compl.trySetResult(())
            default:
                setAbnormalExit()
                compl.trySetError(CargoServiceError.BashDidExitWithNonZeroCode(exitCode: exitCode))
            }
            bash = nil
            compl = TaskCompletionSource()

        case .DidHaltAbnormally:
            setAbnormalExit()
            compl.trySetError(CargoServiceError.BashDidHalt)
            bash = nil
            compl = TaskCompletionSource()
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

    func run(operation: CargoOperation) throws -> Task<()> {
        switch operation {
        case .New(let u):
            let p = u.path ?? ""
            return try runBashSession("cargo new " + p)

        case .Build:
            return try runBashSession("cargo build")

        case .Clean:
            return try runBashSession("cargo clean")
        }
    }
    func cancelAnyOperation() {
        bash?.kill()
        bash = nil
    }
}

//final class TTYService {
//    func launchTTY() ->
//}
//final class TTYSession {
//
//}







