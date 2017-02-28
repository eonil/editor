////
////  BashProcess.swift
////  Editor6Services
////
////  Created by Hoon H. on 2017/01/14.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//
/////
///// Runs a Bash by line unit in a subprocess.
/////
//enum LineBashProcess {
//    enum Command {
//        case stdin(String)
//        /// Sends `SIGTERM` to underlying `bash` subprocess.
//        case terminate
//        /// Sends `SIGKILL` to underlying `bash` subprocess.
//        case kill
//    }
//    enum Event {
//        case stdout(String)
//        case stderr(String)
//        /// Bash subprocess has been quit.
//        /// This event is sent asynchronously. Actual quitting is
//        /// already been done before receiving this event.
//        case quit(Subprocess3.ExitReason)
//    }
//
//    /// Runs a Bash session asynchronouly.
//    ///
//    /// This spawns a new thread which will;
//    /// - Spawn a Bash subprocess.
//    /// - Control interaction between live STDIN/STDOUT/STDERR between Bash
//    ///   and channels.
//    /// 
//    static func spawn() -> PcoIOChannelSet<Command,Event> {
//        let (command, event) = Subprocess3.spawn(path: "/bin/bash", arguments: "--login", "-s")
//        var stdoutLineReader = LineReader()
//        var stderrLineReader = LineReader()
//        let command1 = command.map { (s: Command) -> Subprocess3.Command in
//            switch s {
//            case .stdin(let line):
//                assert(line.hasSuffix("\n") == false)
//                let data = (line + "\n").data(using: .utf8) ?? Data()
//                return .stdin(data)
//            case .terminate:
//                return .terminate
//            case .kill:
//                return .kill
//            }
//        }
//        let event1 = event.bufferedMap { (s: Subprocess3.Event) -> [Event] in
//            switch s {
//            case .stdout(let data):
//                let lines = stdoutLineReader.push(data: data)
//                let events = lines.map { Event.stdout($0) }
//                return events
//
//            case .stderr(let data):
//                let lines = stderrLineReader.push(data: data)
//                let events = lines.map { Event.stdout($0) }
//                return events
//
//            case .quit(let reason):
//                assert(stdoutLineReader.decodedString == "")
//                assert(stderrLineReader.decodedString == "")
//                return [.quit(reason)]
//            }
//        }
//        return (command1, event1)
//    }
//
//    ///
//    /// Executes a command as a line.
//    ///
//    @discardableResult
//    static func run(_ inputLines: String...) -> (exitReason: Subprocess3.ExitReason?, outputLines: [String], errorLines: [String]) {
//        let (cch, ech) = spawn()
//        for line in inputLines {
//            cch.send(.stdin(line))
//        }
//        cch.send(.stdin("exit;"))
//        var outputLines = [String]()
//        var errorLines = [String]()
//        var exitReason = Optional<Subprocess3.ExitReason>.none
//        for e in ech {
//            switch e {
//            case .stdout(let line):
//                outputLines.append(line)
//            case .stderr(let line):
//                errorLines.append(line)
//            case .quit(let reason):
//                exitReason = reason
//            }
//        }
//        return (exitReason, outputLines, errorLines)
//        // Subprocess event channel has been closed unexpectedly.
//    }
//}
