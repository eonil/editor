////
////  CargoService.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/15.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//import EonilSignet
//
/////
///// Manages cargo executions.
/////
///// This basically queues and serializes cargo operations on a workspace.
///// Only one cargo operation can be performed at once for a
///// workspace.
///// Cargo operations for different workspaces won't be serialized.
/////
//final class CargoService {
//    private let loop = ManualLoop()
//    private let watch = Relay<CargoExecution.Transaction>()
//    private var psq = Array<CargoExecution.Parameters>()
//    private var curx: CargoExecution?
//
//    var currentExecutionState: CargoExecution.State? {
//        return curx?.state
//    }
//    init() {
//        loop.step = { [weak self] in self?.step() }
//    }
//    func queue(_ ps: CargoExecution.Parameters) {
//        psq.append(ps)
//        loop.signal()
//    }
////    ///
////    /// Set priority of build process.
////    ///
////    func setPriority(_ p: CargoExecution.Priority) {
////        guard let x = curx else { return }
////        x.setPriority(p)
////    }
//    func haltCurrent() {
//        guard let x = curx else { return }
//        x.halt()
//        curx = nil
//    }
//
//    private func step() {
//        assertMainThread()
//        guard curx == nil else { return }
//        guard let ps = psq.removeFirstIfAvailable() else { return }
//        let x = CargoExecution(ps)
//        x.transaction += watch
//        x.launch()
//        curx = x
//    }
//
//    private func process(_ tx: CargoExecution.Transaction) {
//        guard let x = curx else { REPORT_fatalError("Current execution SHOULD NOT be a `nil`.") }
//        switch tx {
//        case .mode:
//            switch x.state.mode {
//            case .none:
//                break
//            case .running:
//                break
//            case .complete:
//                curx = nil
//                step()
//            }
//        case .priority:
//            break
//        case .messages(let m):
//            REPORT_recoverableWarning("Received an issue while performing a Cargo operation... \(m)")
//            MARK_unimplemented()
//            break
//        }
//    }
//}
