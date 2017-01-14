////
////  WorkspaceProcess.swift
////  Editor6
////
////  Created by Hoon H. on 2016/12/31.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import EonilGCDActor
//
//enum WorkspaceProcessCommand {
////    case newWorkspace
////    case openWorkspace
////    case closeWorkspace
//}
//
//enum DialogueUICommand {
//    case ok
//    case cancel
//}
//
//
//
//enum WorkspaceProcess {
//    static let command = GCDChannel<WorkspaceProcessCommand>()
//    static func spawn() {
//        let panel = PanelProcess()
//        let ref = GCDActor.spawn { [command = command] (_ s: GCDActorSelf) in
//            let cmd = command.receive()
//            switch cmd {
//            case .newWorkspace:
//                let u = panel.saveFile(s)
//                break
//            case .openWorkspace:
//                break
//            case .closeWorkspace:
//                break
//            }
//        }
//    }
//}
//
//enum DialogueProcess {
//    enum Button {
//        case ok
//        case yes
//        case no
//        case cancel
//    }
//    enum Signal {
//
//    }
//    static let signal = GCDChannel<Signal>()
//    static let
//    static func ask(_ s: GCDActorSelf) {
//        s.
//    }
//}
//
//final class PanelProcess {
//    func openFile(_ s: GCDActorSelf) -> [URL]? {
//
//    }
//    func saveFile(_ s: GCDActorSelf) -> URL? {
//
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
