////
////  ADHOC_DialogueUI.swift
////  Editor6
////
////  Created by Hoon H. on 2017/03/05.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import Editor6Common
//
//extension Flow2 {
//    func runSavePanelUI(_ completion: @escaping (URL) -> ()) {
//        let sp = NSSavePanel()
//        let c = RunningFlag()
//        sp.allowedFileTypes = [WorkspaceDocument.filePathExtension]
//        sp.allowsOtherFileTypes = false
//        c.isRunning = true
//        execute { [weak self] _ in
//            sp.begin { [weak self] (_ r: Int) in
//                guard let ss = self else { return }
//                switch r {
//                case NSFileHandlingPanelOKButton:
//                    guard let u = sp.url else { MARK_unimplemented() }
//                    completion(u)
//                case NSFileHandlingPanelCancelButton:
//                    break
//                default:
//                    break
//                }
//                c.isRunning = false
//                ss.signal()
//            }
//        }
//        wait { _ in
//            return c.isRunning
//        }
//    }
//}
//
//private final class RunningFlag {
//    var isRunning = false
//}
