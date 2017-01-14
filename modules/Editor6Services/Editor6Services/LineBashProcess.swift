//
//  BashProcess.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

///
/// Runs a Bash by line unit in a subprocess.
///
enum LineBashProcess {
    enum Command {
        case stdin(String)
        /// Sends `SIGTERM` to underlying `bash` subprocess.
        case terminate
        /// Sends `SIGKILL` to underlying `bash` subprocess.
        case kill
    }
    enum Event {
        case stdout(String)
        case stderr(String)
        /// Bash subprocess has been quit.
        /// This event is sent asynchronously. Actual quitting is
        /// already been done before receiving this event.
        case quit(Subprocess3.ExitReason)
    }

    /// Runs a Bash session asynchronouly.
    ///
    /// This spawns a new thread which will;
    /// - Spawn a Bash subprocess.
    /// - Control interaction between live STDIN/STDOUT/STDERR between Bash
    ///   and channels.
    /// 
    static func spawn() -> PcoIOChannelSet<Command,Event> {
        let (command, event) = Subprocess3.spawn(path: "/bin/bash", arguments: "--login", "-s")
        var stdoutLineReader = LineReader()
        var stderrLineReader = LineReader()
        let command1 = command.map { (s: Command) -> Subprocess3.Command in
            switch s {
            case .stdin(let line):
                assert(line.hasSuffix("\n") == false)
                let data = (line + "\n").data(using: .utf8) ?? Data()
                return .stdin(data)
            case .terminate:
                return .terminate
            case .kill:
                return .kill
            }
        }
        let event1 = event.bufferedMap { (s: Subprocess3.Event) -> [Event] in
            switch s {
            case .stdout(let data):
                let lines = stdoutLineReader.push(data: data)
                let events = lines.map { Event.stdout($0) }
                return events

            case .stderr(let data):
                let lines = stderrLineReader.push(data: data)
                let events = lines.map { Event.stdout($0) }
                return events

            case .quit(let reason):
                assert(stdoutLineReader.decodedString == "")
                assert(stderrLineReader.decodedString == "")
                return [.quit(reason)]
            }
        }
        return (command1, event1)
    }

//    /// Runs a Bash session synchronously.
//    ///
//    /// This function performs these operations synchronously;
//    /// 1. Spawn a subprocess which runs Bash.
//    /// 2. Push supplied `input` into the Bash subprocess' STDIN.
//    /// 3. Wait until the Bash exits.
//    /// 4. Collect STDOUT and STDERR and return.
//    ///
//    /// - Warning:
//    ///     Configure your `input` to guarantee the Bash to exit eventually.
//    ///     Otherwise, this function won't return forever.
//    ///
//    /// - Parameter input:
//    ///     A byte array which will be passed to Bash's STDIN.
//    ///     This supposed to be a command lines with ending new-line
//    ///     characters. This also can be a true binary data if your
//    ///     Bash session is expecting binary data.
//    ///
//    /// - Returns:
//    ///     A tuple of STDOUT and STDERR collected during running of Bash.
//    ///
//    static func run(_ input: Data) -> (output: Data, error: Data) {
//        let (command, event) = spawn()
//        var output = Data()
//        command.send(.stdin(input))
//        event.receive {
//            switch $0 {
//            case .stdout(let data):
//                output.append(data)
//            case .terminate:
//                command.close()
//            }
//        }
//        error.receive(with: <#T##(Error) -> ()#>)
//        return output
//    }
}
