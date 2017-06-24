//
//  CargoExecution.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/16.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilSignet

final class CargoExecution {
    let parameters: Parameters
    private(set) var state = State()
    ///
    /// Notifies detailed informations about each transactions.
    /// This is basically provided for optimization.
    ///
    let transaction = Relay<Transaction>()
    private let bashExecution: BashExecution
    private let bashWatch = Relay<BashExecution.Event>()

    init(_ ps: Parameters) {
        parameters = ps
        func makeArguments() -> [String] {
            switch ps.command {
            case .initialize:   return ["init"]
            case .clean:        return ["clean"]
            case .build:        return ["build"]
            case .run:          return ["run"]
            }
        }
        let args = makeArguments()
        bashExecution = BashExecution(command: "cargo", arguments: args)
        bashWatch.watch(bashExecution.event)
    }
    deinit {
        bashWatch.unwatch()
    }
    ///
    /// Idempotent.
    /// Once launched execution won't be launched again.
    ///
    func launch() {
        bashExecution.process(.initiate)
    }
    ///
    /// Idempotent.
    /// Once halted execution won't be launched again.
    ///
    func halt() {
        bashExecution.process(.terminate)
    }
    func setPriority(_ newPriority: Priority) {
        guard state.priority != newPriority else { return }
        state.priority = newPriority
        transaction.cast(.priority)
    }
}

extension CargoExecution {
    struct Parameters {
        var location: URL
        var command: Command
    }
    enum Command {
        case initialize
        case clean
        case build
        case run
    }
    struct State {
        var mode = Mode.none
        var priority = Priority.secondary
        var issues = [Issue]()
    }
    enum Mode {
        case none
        case running(RationalInt)
        case complete
    }
    enum Transaction {
        case mode
        case priority
        case issues(ArrayMutation<Issue>)
    }
    enum Issue {
        case rustcWarning
        case rustcError
    }
    enum Priority {
        case primary
        case secondary
    }
}
