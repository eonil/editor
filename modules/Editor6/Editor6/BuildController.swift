//
//  BuildController.swift
//  Editor6
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilGCDActor

final class BuildController {
    
}

enum BuildProcess {
    enum Command {
        case run
        case halt
    }
    enum Event {
        case complete
        case error(Error)
    }
    enum Problem: Error {
        case inappropriateCommand(Command)
    }
    static func spawn(command: CommandChannel<Command>, event: EventChannel<Event>, error: ErrorChannel) {
        GCDActor.spawn { (_ ss: GCDActorSelf) in
            do {
                let cmd = command.receive()
                guard case .run = cmd else { throw Problem.inappropriateCommand(cmd) }
                
            }
            catch let e {
                error.send(e)
            }
        }
    }
}














struct CommandChannel<T> {
    private let gcdch = GCDChannel<T>()
    fileprivate func receive() -> T {
        return gcdch.receive()
    }
    func send(_ signal: T) {
        gcdch.send(signal)
    }
}
struct EventChannel<T> {
    private let gcdch = GCDChannel<T>()
    fileprivate func send(_ signal: T) {
        gcdch.send(signal)
    }
    func receive() -> T {
        return gcdch.receive()
    }
}
struct ErrorChannel {
    private let gcdch = GCDChannel<Error>()
    fileprivate func send(_ signal: Error) {
        gcdch.send(signal)
    }
    func receive() -> Error {
        return gcdch.receive()
    }
}
