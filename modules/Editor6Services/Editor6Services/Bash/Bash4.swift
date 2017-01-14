////
////  Bash4.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/11/30.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import EonilFlow4
//
//enum Bash4Event {
//    case terminate(exitCode: Int32)
//    case output(lines: [String])
//    case error(lines: [String])
//}
//
///// Create a subprocess and executes Bash in there.
/////
///// Requirements
///// ------------
///// - `/bin/bash` must be installed on system.
/////
///// - Note:
/////     Its impossible each command in Bash shell
/////     finished or not. Instead, you need to monitor
/////     exit of the Bash shell itself, and reinstantiate
/////     a new Bash shell for each command if you need
/////     to track execution time of them.
/////
//final class Bash4 {
//    //    struct State {
//    //        var lines = [LogLine]()
//    //    }
//    //    enum LogLine {
//    //        case write(WriteLine)
//    //        case read(ReadLine)
//    //    }
//    enum WriteLine {
//        case stdin(String)
//    }
//    enum ReadLine {
//        case stdout(String)
//        case stderr(String)
//    }
//    typealias Delegate = (_ action: Bash4Event) -> ()
//
//    private let subproc: Subprocess2Controller
//    private var delegate = Delegate?.none
//    private var stdoutReader = LineReader()
//    private var stderrReader = LineReader()
//    private var readBuffer = [ReadLine]()
//
//    init() {
//        subproc = Subprocess2Controller(path: "/bin/bash", arguments: ["--login", "-s"])
//        subproc.delegate { [weak self] in self?.process($0) }
//        subproc.launch()
//    }
//    deinit {
//    }
//
//    var isRunning: Bool {
//        return subproc.state.phase == .running
//    }
//
//    ///
//    /// - Note:
//    ///     Will be called from another GCDQ.
//    ///
//    func delegate(to newDelegate: @escaping Delegate) {
//        delegate = newDelegate
//    }
//
//    ///
//    /// - Parameter newLines:
//    ///     Exclude ending `\n` character.
//    ///
//    func dispatch(_ newLines: [WriteLine]) {
//        let a = newLines.map({ $0.getString() })
//        dispatch(a)
//    }
//    func dispatch(_ newLines: [String]) {
//        let s = newLines.map({ $0 + "\n" }).joined()
//        let d = s.data(using: .utf8) ?? Data()
//        subproc.dispatch(command: .stdin(d))
//    }
//    private func process(_ event: Subprocess2Event) {
//        switch event {
//        case .terminate(let exitCode):
//            delegate?(.terminate(exitCode: exitCode))
//        case .stdout(let data):
//            let newLines = stdoutReader.push(data: data)
//            delegate?(.output(lines: newLines))
//        case .stderr(let data):
//            let newLines = stderrReader.push(data: data)
//            delegate?(.error(lines: newLines))
//        }
//    }
//}
//
//extension Bash4 {
//    ///
//    /// Runs simple command and gets result.
//    /// You have to instantiate a Bash4 object if you want
//    /// to execute Bash interactively.
//    ///
//    static func run(commands: [String]) -> Flow4<(logs: [ReadLine], exitCode: Int32)> {
//        return gcdq.flow(with: ()).step({ (_: (), signal) in
//            let bash = Bash4()
//            var lines = [ReadLine]()
//            var exitCode = Int32()
//            bash.delegate { action in
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
//fileprivate extension Bash4.WriteLine {
//    func getString() -> String {
//        switch self {
//        case .stdin(let s): return s
//        }
//    }
//}
