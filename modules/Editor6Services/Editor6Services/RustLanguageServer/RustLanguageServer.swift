////
////  RustLanguageServer.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/20.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import Flow
//
//struct RLSState {
//}
//
//enum RLSMessage {
//    case query(file: URL, line: Int, column: Int)
//}
//enum RLSNotification {
//    case candidiates(RLSCandidate)
//}
//
//struct RLSSourceCodeRange {
//    var start: RLSSourceCodeLocation
//    var end: RLSSourceCodeLocation
//}
//struct RLSSourceCodeLocation {
//    var line: Int
//    var column: Int
//}
//struct RLSCandidate {
//    var functionName: String
//}
//
//final class RustLanguageServer {
//    private var delegate: ((RLSNotification) -> ())?
//    private var state = RLSState()
//
//    func delegate(to newDelegate: @escaping (RLSNotification) -> ()) {
//        delegate = newDelegate
//    }
//    func process(_ message: RLSMessage) {
//        switch message {
//        case .query(let file, let line, let column):
//            // TODO: Do some async query...
//            //       and dispatch result to delegate.
//            break
//        }
//    }
////    func query(file: URL, line: Int, column: Int) -> Step<()> {
////        DispatchQueue.main.flow(with: ())
////    }
//
//    private func processServerResponse(response: ()) {
//
//    }
//}
