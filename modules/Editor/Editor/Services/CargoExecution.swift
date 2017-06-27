////
////  CargoExecution.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/16.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//import EonilSignet
//
//final class CargoExecution {
//    let parameters: Parameters
//    private(set) var state = State()
//    private let bashExecution: BashExecution
//    private let bashWatch = Relay<BashExecution.Event>()
//    private var stdoutLines = LineBuilder()
//    private var stderrLines = LineBuilder()
//    ///
//    /// Notifies detailed informations about each transactions.
//    /// This is basically provided for optimization.
//    ///
//    let transaction = Relay<Transaction>()
//
//    init(_ ps: Parameters) {
//        parameters = ps
//        func makeArguments() -> [String] {
//            switch ps.command {
//            case .initialize:   return ["init"]
//            case .clean:        return ["clean"]
//            case .build:        return ["build"]
//            case .run:          return ["run"]
//            }
//        }
//        let args = makeArguments()
//        bashExecution = BashExecution(command: "cargo", arguments: args, login: true)
//        bashWatch.delegate = { [weak self] in self?.processBashExecutionEvent($0) }
//        bashExecution.event += bashWatch
//    }
//    deinit {
//        bashExecution.event -= bashWatch
//    }
//    private func processBashExecutionEvent(_ e: BashExecution.Event) {
//        assertMainThread()
//        switch e {
//        case .launch:           bashDidLaunch()
//        case .stdout(let d):    bashDidStandardOutputLine(stdoutLines.process(d))
//        case .stderr(let d):    bashDidStandardErrorLine(stderrLines.process(d))
//        case .exit(let r):      bashDidExit(r)
//        }
//    }
//
//    ///
//    /// Idempotent.
//    /// Once launched execution won't be launched again.
//    ///
//    func launch() {
//        bashExecution.process(.initiate)
//        state.mode = .running
//        transaction.cast(.mode)
//    }
//    ///
//    /// Idempotent.
//    /// Once halted execution won't be launched again.
//    ///
//    func halt() {
//        bashExecution.process(.terminate)
//    }
////    func setPriority(_ newPriority: Priority) {
////        guard state.priority != newPriority else { return }
////        state.priority = newPriority
////        transaction.cast(.priority)
////    }
//
//
//
//    private func bashDidLaunch() {
//        precondition(state.mode == .running)
//    }
//    private func bashDidStandardOutputLine(_ r: Result<[String], LineBuilder.Issue>) {
//        switch r {
//        case .failure(let e):
//            processIssue(.cannotDecodeStandardOutput(e))
//        case .success(let v):
//            processMessage(.info(v.joined(separator: "")))
//        }
//    }
//    private func bashDidStandardErrorLine(_ r: Result<[String], LineBuilder.Issue>) {
//        switch r {
//        case .failure(let e):
//            processIssue(.cannotDecodeStandardError(e))
//        case .success(let v):
//            // Parse line.
//            DEBUG_log(v)
////            MARK_unimplemented()
//        }
//    }
//    private func bashDidExit(_ r: Int32) {
//        precondition(state.mode == .running)
//        bashDidStandardOutputLine(.success([stdoutLines.construction]))
//        bashDidStandardErrorLine(.success([stderrLines.construction]))
//        state.mode = .complete
//        transaction.cast(.mode)
//    }
//    private func processIssue(_ e: Issue) {
//        precondition(state.mode == .running)
//        state.mode = .complete
//        state.issues.append(e)
//        transaction.cast(.mode)
//    }
//    private func processMessage(_ m: Message) {
//        precondition(state.mode == .running)
//        let c = state.messages.count
//        state.messages.append(m)
//        transaction.cast(.messages(.insert(c..<c+1)))
//    }
//}
//
//extension CargoExecution {
//    struct Parameters {
//        var location: URL
//        var command: Command
//    }
//    enum Command {
//        case initialize
//        case clean
//        case build
//        case run
//    }
//    struct State {
//        var mode = Mode.none
//        var priority = Priority.secondary
//        var messages = [Message]()
//        var issues = [Issue]()
//    }
//    enum Mode {
//        case none
////        case running(RationalInt)
//        case running
//        case complete
//    }
//    enum Transaction {
//        case mode
//        case priority
//        case messages(ArrayMutation<Message>)
//    }
//    ///
//    /// Output emission from Cargo operation.
//    /// This is problems of input files for Cargo operation.
//    /// Cargo execution itself is OK.
//    ///
//    enum Message {
//        case info(String)
//        case rustcWarning
//        case rustcError
//    }
//    ///
//    /// Cargo execution failure reason.
//    /// Don't be confused. This means an error in Cargo execution.
//    ///
//    enum Issue {
//        case cannotDecodeStandardOutput(LineBuilder.Issue)
//        case cannotDecodeStandardError(LineBuilder.Issue)
//        case unexpectedStandardOutput(String)
//    }
//    enum Priority {
//        case primary
//        case secondary
//    }
//}
