//
//  CargoService.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilSignet

///
/// Manages cargo executions.
///
/// This basically queues and serializes cargo operations on a workspace.
/// Only one cargo operation can be performed at once for a
/// workspace.
/// Cargo operations for different workspaces won't be serialized.
///
final class CargoService {
    private let watch = Relay<CargoExecution.Transaction>()
    private var psq = Array<CargoExecution.Parameters>()
    private var curx: CargoExecution?

    var currentExecutionState: CargoExecution.State? {
        return curx?.state
    }
    func queue(_ ps: CargoExecution.Parameters) {
        psq.append(ps)
        step()
    }
    ///
    /// Set priority of build process.
    ///
    func setPriority(_ p: CargoExecution.Priority) {
        guard let x = curx else { return }
        x.setPriority(p)
    }
    func haltCurrent() {
        guard let x = curx else { return }
        x.halt()
        curx = nil
    }

    private func step() {
        guard curx == nil else { REPORT_fatalError("There's a on-going Cargo execution.") }
        while let ps = psq.removeFirstIfAvailable() {
            let x = CargoExecution(ps)
            watch.watch(x.transaction)
            x.launch()
            curx = x
        }
    }

    private func process(_ tx: CargoExecution.Transaction) {
        guard let x = curx else { REPORT_fatalError("Current execution SHOULD NOT be a `nil`.") }
        switch tx {
        case .mode:
            switch x.state.mode {
            case .none:
                break
            case .running(let progress):
                break
            case .complete:
                curx = nil
                step()
            }
        case .priority:
            break
        case .issues(let m):
            break
        }
    }
}
