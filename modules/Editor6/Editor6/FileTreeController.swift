////
////  FileTreeController.swift
////  Editor6
////
////  Created by Hoon H. on 2016/12/27.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import Editor6WorkspaceUI
//
//final class FileTreeController {
////    private var addNewFileProcess: AddNewFileProcess?
//    func addNewFile() {
//    }
//    func process(_ id: FileTreeProcessID) {
//        switch id {
//            case .addNewFile:
//            break
//        }
//    }
//}
//
//enum FileTreeProcessID {
//    case addNewFile
//}
//
/////
///// Collection of file tree management processes.
/////
///// File management runs single process, and performs
///// everything sequentially. This is by-design
///// because human user cannot do multiple operations
///// at once. No one can create and delete files at once
///// simultaneously.
/////
///// - File management process performs one operation
/////   at once.
///// - Some operations can be cancelled, halted.
///// - Some operations uninterruptible. Case by case.
/////
///// If you need to build a concurrent execution flow,
/////
//private enum FileManagement {
//    enum Job {
//        case addNewFile
//        case deleteSelectedFile
////        case
//    }
//    enum Action {
////        case addNewFile(AddNewFileAction)
//    }
//}
//
//private enum AddNewFileProcess {
//    enum Action {
//        case pickNewFileType(String)
//        case submitNewFileName(String)
//    }
//    enum Control {
//        case beginNewFileTypePickingSheet
//        case endNewFileTypePickingSheet
//        case selectNewFileNodeInTree
//        case startEditingName(String)
//        case endEditingName
//    }
//    enum Result {
//        case ok
//        case cancel
//    }
//    enum Trouble: Error {
//        case unexpectedHalt
//        case unexpectedAction
//    }
//    static func spawn() -> PcoIOChannelSet<Action,Control> {
//        return Pco.spawn { incoming, outgoing in
//
//            func addNewFile() throws {
//                try chooseNewFileType()
//                try editFileName()
//            }
//            try addNewFile()
//
//            func chooseNewFileType() throws {
//                outgoing.send(.beginNewFileTypePickingSheet)
//                guard let s1 = incoming.receive() else { throw Trouble.unexpectedHalt }
//                guard case .pickNewFileType(let newFileType) = s1 else { throw Trouble.unexpectedAction }
//                outgoing.send(.endNewFileTypePickingSheet)
//            }
//            func editFileName() throws {
//                /// Create a new file actually.
//                outgoing.send(.startEditingName("")) // NOSHIP: Use actual proper name generated and created.
//                guard let action = incoming.receive() else { throw Trouble.unexpectedHalt }
//                guard case .submitNewFileName(let newFileName) = action else { throw Trouble.unexpectedAction }
//                outgoing.send(.endEditingName)
//            }
//        }
//    }
//
//}
