////
////  FileTreeAction.swift
////  Editor6FileTreeUI
////
////  Created by Hoon H. on 2016/10/08.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
//enum FileTreeCommand {
//    case render(state: FileTreeState)
//    case add(childState: FileState, atIndex: Int, ofParent: FileID)
//    case remove(id: FileID)
//}
//
//struct FileTreeState {
//    var root = FileID()
//    var files = [FileID: FileState]()
//    init(rootName: String) {
//        files[root] = FileState(name: "")
//    }
//}
//
//enum FileTreeAction {
//    case didChangeSelection(FileTreeSelection)
//}
//
//
//
//
//
//
//struct FileTreeSelectionState {
//    private weak var sourceOutlineView: NSOutlineView?
////    var count: Int {
////        return source
////    }
//}
//
//
//
//
//
//
//struct FileID: Hashable {
//    fileprivate let core = FileIDCore()
//    var hashValue: Int {
//        return ObjectIdentifier(core).hashValue
//    }
//}
//private final class FileIDCore: NSObject {}
//func == (_ a: FileID, _ b: FileID) -> Bool {
//    return a.core === b.core
//}
//
//struct FileState {
//    var name: String
//    init(name: String) {
//        self.name = name
//    }
//}
//
//struct FileTreeSelection {
////    var count: Int {
////
////    }
////    subscript(index: Int) -> FileID {
////        
////    }
//}
//
//
//
//
//
//
//
