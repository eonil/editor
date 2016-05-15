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
    var isExecutableReady = false
    var canBuild = false
    var canClean = false
    var canCancel = false
    var buildErrors = [CargoError]()
}
enum CargoError: ErrorType {
    case CompilerWarning(String)
    case CompilerError(String)
}
enum CargoOperation {
    case New
    case Clean
    case Build
}
enum CargoServiceError: ErrorType {
    case AlreadyRunningAnotherOperation
    case BashDidExitWithNonZeroCode(exitCode: Int32)
    case BashDidTerminateAbnormally
}
/// You cannot run any operation while another operation is running.
/// You can try:
/// - Wait until the oepration finishes.
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
    private var bash: BashSubprocess?
    private func runBashSession(command: String) throws -> Task<()> {
        guard bash == nil else { throw CargoServiceError.AlreadyRunningAnotherOperation }

        state.buildErrors = []
        let compl = TaskCompletionSource<()>()
        let newBash = BashSubprocess()
        newBash.onEvent = { [weak self] in
            switch $0 {
            case .StandardOutputDidPrintLine(let line):
                self?.pushStandardOutputLine(line)

            case .StandardErrorDidPrintLine(let line):
                self?.pushStandardErrorLine(line)

            case .DidExit(let exitCode):
                switch exitCode {
                case 0:
                    compl.trySetResult(())
                default:
                    compl.trySetError(CargoServiceError.BashDidExitWithNonZeroCode(exitCode: exitCode))
                }

            case .DidTerminate:
                compl.trySetError(CargoServiceError.BashDidTerminateAbnormally)
            }
        }
        try newBash.runCommand(command)
        bash = newBash
    }
    private func pushStandardOutputLine(line: String) {
        MARK_unimplemented()
    }
    private func pushStandardErrorLine(line: String) {
        MARK_unimplemented()
    }

    func run(operation: CargoOperation) throws -> Task<()> {
        switch operation {
        case .New:
            return try runBashSession("cargo new").continueWith(continuation: { [weak self] (task: Task<()>) -> () in
                return self?.updateState()
            })

        case .Build:
            return try runBashSession("cargo build").continueWith(continuation: { [weak self] (task: Task<()>) -> () in
                return self?.updateState()
            })

        case .Clean:
            return try runBashSession("cargo clean").continueWith(continuation: { [weak self] (task: Task<()>) -> () in
                return self?.updateState()
            })

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







