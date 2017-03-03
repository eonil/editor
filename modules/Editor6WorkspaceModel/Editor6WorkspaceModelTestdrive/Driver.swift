////
////  Driver.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/30.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import Editor6WorkspaceModel
//
//final class Driver {
//    private let wsm: WorkspaceModel
//    private let loop = WorkspaceModelMessageLoop()
//    init() {
//        WorkspaceModel.initializeGlobals()
//        wsm = WorkspaceModel()
//        wsm.delegate(to: loop)
////        wsm.debug.addTarget(executable: URL(fileURLWithPath: "")).step { [weak self] (newTargetID: DebugTargetID) -> () in
////            guard let s = self else { return }
////            print(newTargetID)
////        }.step { (r: Result<()>) in
////            print(r)
////        }
//        wsm.relocate(URL(fileURLWithPath: "/Users/Eonil/Temp/p1", isDirectory: true)).cleanse(report)
//        wsm.addFile(name: "A", group: true, note: nil, data: Data(), at: 0, in: ProjectItemID([])).cleanse(report)
//
//        loop.process { (t: ModelTransaction<WorkspaceState>) in
//            print(t)
//        }
//    }
//    deinit {
//        WorkspaceModel.terminateGlobals()
//    }
//}
//
//private func report(_ error: Error) {
//    fatalError("\(error)")
//}
