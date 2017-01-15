//
//  Subprocess.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

enum Subprocess3 {
    enum Command {
        case stdin(Data)
        ///
        /// Sends `SIGTERM` to underlying subprocess
        /// to make it quit gracefully.
        ///
        case terminate
        ///
        /// Sends `SIGKILL` to underlying subprocess
        /// to force it quit immediately unconditionally.
        ///
        case kill
    }
    enum Event {
        case stdout(Data)
        case stderr(Data)
        case quit(ExitReason)

    }
    enum ExitReason {
        case terminate(exitCode: Int32)
        case kill
    }

    static func spawn(path: String, arguments: String...) -> PcoIOChannelSet<Command,Event> {
        return spawn(path: path, arguments: arguments)
    }

    /// - Note:
    ///     A subprocess will be launched automatically ASAP after you call
    ///     this function.
    ///
    /// - Parameter path: Path to executable file.
    /// - Parameter arguments: Arguments will be passed to executable on launch.
    ///
    static func spawn(path: String, arguments: [String]) -> PcoIOChannelSet<Command,Event> {
        return Pco.spawn { command, event in
            let stdinPipe = Pipe()
            let stdoutPipe = Pipe()
            let stderrPipe = Pipe()

            let proc = Process()
            let read = { (f: FileHandle) -> (Data) in return f.availableData }

            stdoutPipe.fileHandleForReading.readabilityHandler = { event.send(.stdout(read($0))) }
            stderrPipe.fileHandleForReading.readabilityHandler = { event.send(.stderr(read($0))) }
            proc.standardInput = stdinPipe
            proc.standardOutput = stdoutPipe
            proc.standardError = stderrPipe
            proc.launchPath = path
            proc.arguments = arguments
            proc.terminationHandler = { proc in
                let c = proc.terminationStatus
                event.send(.quit(.terminate(exitCode: c)))
            }
            proc.launch()

            for s in command {
                switch s {
                case .stdin(let data):
                    stdinPipe.fileHandleForWriting.write(data)
                case .terminate:
                    proc.terminate()
                    // NOSHIP: Confirm whether this to make a termination event.
                case .kill:
                    let pid = proc.processIdentifier
                    kill(pid, SIGKILL)
                    // NOSHIP: Confirm whether this to make a termination event.
                }
            }
            event.send(nil)
        }
    }
}

extension Subprocess3 {
//    /// Supports only programs which have fixed locations.
//    enum Program {
//        case bash
//
//        func getParams() -> (path: String, arguments: [String]) {
//            switch self {
//            case .bash:
//                return ("/bin/bash", ["--login", "-s"])
//        }
//    }
//
//    static func spawn(program: Program) -> PcoIOChannelSet<Command, Event> {
//        let (path, arguments) = program.getParams()
//        return Subprocess3.spawn(path: path, arguments: arguments)
//    }

    static func spawnBash() -> PcoIOChannelSet<Command,Event> {
        return spawn(path: "/bin/bash", arguments: "--login", "-s")
    }

    /// Runs a subprocess session synchronously.
    ///
    /// This function performs these operations synchronously;
    /// 1. Spawn a subprocess with designed executable at path.
    /// 2. Push supplied `input` into the subprocess' STDIN.
    /// 3. Wait until the subprocess exits.
    /// 4. Collect STDOUT and STDERR and return.
    ///
    /// - Warning:
    ///     Configure your `input` to guarantee the subprocess to exit eventually.
    ///     Otherwise, this function won't return forever.
    ///
    /// - Parameter input:
    ///     A byte array which will be passed to subprocess' STDIN.
    ///
    /// - Returns:
    ///     A tuple of STDOUT and STDERR collected during running of subprocess.
    ///
    static func run(path: String, arguments: String..., input: Data) -> (output: Data, error: Data) {
        let (command, event) = spawn(path: path, arguments: arguments)
        var output = Data()
        var error = Data()
        command.send(.stdin(input))
        for s in event {
            switch s {
            case .stdout(let data):
                output.append(data)
            case .stderr(let data):
                error.append(data)
            case .quit(_):
                command.send(nil)
            }
        }
        return (output, error)
    }
}
