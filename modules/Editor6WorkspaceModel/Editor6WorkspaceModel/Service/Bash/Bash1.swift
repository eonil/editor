////
////  Bash1Controller.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/18.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import Flow
//
///// Create a subprocess and executes Bash in there.
///// 
///// Requirements
///// ------------
///// - `/bin/bash` must be installed on system.
///// 
///// - Note:
/////     Its impossible each command in Bash shell
/////     finished or not. Instead you need to monitor
/////     exit of the Bash shell itself, and reinstantiate
/////     a new Bash shell for each command if you need
/////     to track execution time of them.
/////
//final class Bash1 {
//    enum Event {
//        case terminate(exitCode: Int32)
//        case output(lines: [String])
//        case error(lines: [String])
//    }
////    struct State {
////        var lines = [LogLine]()
////    }
////    enum LogLine {
////        case write(WriteLine)
////        case read(ReadLine)
////    }
//    enum WriteLine {
//        case stdin(String)
//    }
//    enum ReadLine {
//        case stdout(String)
//        case stderr(String)
//    }
//    typealias Delegate = (_ sender: Bash1, _ action: Event) -> ()
//
//    private let subproc: Subprocess1Controller
//    private var delegate = Delegate?.none
//    private var stdoutReader = LineReader()
//    private var stderrReader = LineReader()
//    private var readBuffer = [ReadLine]()
//
//    init(ioQueuePair: IOQueuePair = .main) {
//        subproc = Subprocess1Controller(path: "/bin/bash", arguments: ["--login", "-s"], ioQueuePair: ioQueuePair)
//        subproc.delegate { [weak self] in self?.process($0, $1) }
//        subproc.launch()
//    }
//    deinit {
//    }
//
//    var isRunning: Bool {
//        return subproc.state.phase == .running
//    }
//
//    /// - Note:
//    ///     Will bw called from another GCDQ.
//    func delegate(to newDelegate: @escaping Delegate) {
//        delegate = newDelegate
//    }
//    /// - Parameter newLines:
//    ///     Exclude ending `\n` character.
//    func dispatch(_ newLines: [WriteLine]) {
//        let a = newLines.map({ $0.getString() })
//        dispatch(a)
//    }
//    func dispatch(_ newLines: [String]) {
//        let s = newLines.map({ $0 + "\n" }).joined()
//        let d = s.data(using: .utf8) ?? Data()
//        subproc.dispatch(data: d)
//    }
//    private func process(_ sender: Subprocess1Controller, _ action: Subprocess1Action) {
//        switch action {
//        case .terminate(let exitCode):
//            delegate?(self, .terminate(exitCode: exitCode))
//        case .stdout(let data):
//            let newLines = stdoutReader.push(data: data)
//            delegate?(self, .output(lines: newLines))
//        case .stderr(let data):
//            let newLines = stderrReader.push(data: data)
//            delegate?(self, .error(lines: newLines))
//        }
//    }
//}
//
//extension Bash1 {
//    @available(*,deprecated: 0.0)
//    static func run(commands: [String], on gcdq: DispatchQueue) -> Step<(logs: [ReadLine], exitCode: Int32)> {
//        return gcdq.flow(with: ()).step({ (_: (), signal) in
//            let ioqp = IOQueuePair(readQueue: gcdq, writeQueue: gcdq)
//            let bash = Bash1(ioQueuePair: ioqp)
//            var lines = [ReadLine]()
//            var exitCode = Int32()
//            bash.delegate { sender, action in
//                switch action {
//                case .output(let newLines):
//                    lines.append(contentsOf: newLines.map(ReadLine.stdout))
//                case .error(let newLines):
//                    lines.append(contentsOf: newLines.map(ReadLine.stderr))
//                case .terminate(let newExitCode):
//                    exitCode = newExitCode
//                    signal.ok(logs: lines, exitCode: exitCode)
//                }
//            }
//            bash.dispatch(commands)
//        })
//    }
//}
//
//fileprivate extension Bash1.WriteLine {
//    func getString() -> String {
//        switch self {
//        case .stdin(let s): return s
//        }
//    }
//}
