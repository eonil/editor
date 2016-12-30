////
////  Cargo1.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/22.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import Flow
//
//enum Cargo1 {}
//enum Cargo1Event {
//    case issue(Cargo1Issue)
//    case error(Cargo1Error)
//}
//struct Cargo1Issue {
//}
//enum Cargo1Error: Error {
//    case cannotFindParentDirectory
//}
//extension Cargo1 {
//    typealias Return = (halt: () -> (), flow: Step<()>)
//    static func new(location: URL, notify: @escaping (Cargo1Issue) -> ()) -> Return {
//        let parentURL = location.deletingLastPathComponent()
//        let name = location.lastPathComponent
//        let parentPath = parentURL.path
//        guard FileManager.default.fileExists(atPath: parentPath) else {
//            return ({}, DispatchQueue.main.flow(with: ()).error(Cargo1Error.cannotFindParentDirectory))
//        }
//        let cmds = [
//            "cd \(parentPath)",
//            "cargo new \(name)",
//        ]
//        let (stdin, bash) = Bash4.run(ioQueuePair: .makeDualSerialBackground()) { (n: Bash2Notification) in
//            switch n {
//            case .stdout(let line):
//                notify(Cargo1Issue())
//            case .stderr(let line):
//                notify(Cargo1Issue())
//            }
//        }
//        let halt = {
//            /// https://en.wikipedia.org/wiki/Control-C
//            /// https://en.wikipedia.org/wiki/End-of-Text_character
//            stdin("\u{0003}")
//        }
//        return (halt, bash)
//    }
//
//}
