//
//  CargoProcess.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilPco

enum CargoProcess {
    enum Command {
        case terminate
        case kill
    }
    enum Event {
        /// NOSHIP: Use a proper event.
        case ADHOC_stdoutLine(String)
        /// NOSHIP: Use a proper event.
        case ADHOC_stderrLine(String)
        case compileInfo(String)
        case compileWarning(String)
        case compileError(String)
        case cancelByUnknownError
        case cancelByKillCommand
        case complete
    }
    static func spawnInit(location: String) -> PcoIOChannelSet<Command,Event> {
        return spawn(commands: ["cd \(location)", "cargo init"])
    }
    static func spawnBuild(location: String) -> PcoIOChannelSet<Command,Event> {
        return spawn(commands: ["cd \(location)", "cargo build"])
    }
    static func spawnClean(location: String) -> PcoIOChannelSet<Command,Event> {
        return spawn(commands: ["cd \(location)", "cargo clean"])
    }
    private static func spawn(commands: [String]) -> PcoIOChannelSet<Command,Event> {
        let (command, event) = LineBashProcess.spawn()
        let command1 = command.map { (s: Command) -> LineBashProcess.Command in
            switch s {
            case .terminate:
                return .terminate
            case .kill:
                return .kill
            }
        }
        let event1 = event.bufferedMap { (s: LineBashProcess.Event) -> ([Event]) in
            switch s {
            case .stdout(let line):
                return [.ADHOC_stdoutLine(line)]

            case .stderr(let line):
                return [.ADHOC_stderrLine(line)]

            case .quit(let reason):
                switch reason {
                case .terminate(let exitCode):
                    if exitCode == 0 {
                        return [.complete]
                    }
                    else {
                        return [.cancelByUnknownError]
                    }
                case .kill:
                    return [.cancelByKillCommand]
                }
            }
        }
        for cmd in commands {
            command.send(.stdin(cmd))
        }
        return (command1, event1)
    }
}
