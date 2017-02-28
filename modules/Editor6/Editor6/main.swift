//
//  main.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

//import Darwin
//
//var exitCode = Int32?.none
//do {
//    let driver = Driver()
//    exitCode = driver.run()
//}
//guard let exitCode = exitCode else { fatalError("Could not resolve exit-code.") }
//exit(exitCode)

import Foundation
import AppKit
import Editor6WorkspaceUI

enum DocumentObserver {
    enum Note {
        case documentInit(WorkspaceDocument)
        case documentDeinit(WorkspaceDocument)
    }
    static func note(_ n: Note) {
        noteImpl?(n)
    }
    fileprivate static var noteImpl: ((Note) -> ())?
}

do {
    enum MasterFlowControlSignal {
        case boot
        case initWorkspaceDocument(WorkspaceDocument)
        case deinitWorkspaceDocument(WorkspaceDocument)
        case spawnWorkspace
        case killWorkspace(WorkspaceUIID)
        case term
        //        case test1(Test1Command)
    }
    enum Test1Command {
        case newWorkspace
        case closeWorkspace(WorkspaceUIID)
    }
    enum WorkspaceSignal {
        case action(WorkspaceUIAction)
    }
    let masterFlowControlChannel = ThreadChannel<MasterFlowControlSignal>()
    var workspaceUIMapping = [ObjectIdentifier: (ThreadChannel<WorkspaceSignal>, WorkspaceUIWindowController)]()

    DocumentObserver.noteImpl = {
        func killWorkspace(_ wid: ObjectIdentifier) {
            workspaceUIMapping[wid] = nil
        }
        switch $0 {
        case .documentInit(let d):
            let wch = ThreadChannel<WorkspaceSignal>()
            let wwc = WorkspaceUIWindowController()
            let ws = WorkspaceUIState()
            wwc.delegate { wch.signal(.action($0)) }
            wwc.reload(ws)
            wwc.showWindow(nil)
            let wid = ObjectIdentifier(d)
            workspaceUIMapping[wid] = (wch, wwc)
            func workspaceFlow() {
                while let s = wch.wait() {
                    switch s {
                    case .action(let a):
                        switch a {
                        case .close:
                            DispatchQueue.main.sync {
                                killWorkspace(wid)
                            }
                        }
                    }
                }
            }
            Thread.detachNewThread { workspaceFlow() }
        case .documentDeinit(let d):
            let wid = ObjectIdentifier(d)
            killWorkspace(wid)
        }
    }
    func spawnWorkspaceFlow() -> WorkspaceUIID {
        let wid = WorkspaceUIID()
        Thread.detachNewThread {

            let wch = ThreadChannel<WorkspaceSignal>()
            DispatchQueue.main.sync {
                let wwc = WorkspaceUIWindowController()
                let ws = WorkspaceUIState()
                wwc.delegate { wch.signal(.action($0)) }
                wwc.reload(ws)
                wwc.showWindow(nil)
                workspaceUIMapping[wid] = wwc
            }

        }
        return wid
    }
    func killWorkspaceFlow(workspaceID: WorkspaceUIID) {
        DispatchQueue.main.sync {
            workspaceUIMapping[workspaceID] = nil
        }
    }

    // In another thread...
    Thread.detachNewThread {
        while let s = masterFlowControlChannel.wait() {
            switch s {
            case .boot:
                masterFlowControlChannel.signal(.spawnWorkspace)
                break
            case .spawnWorkspace:
                let wid = spawnWorkspaceFlow()
            case .killWorkspace(let wid):
                killWorkspaceFlow(workspaceID: wid)
            case .term:
                break
            }
        }
    }

    @objc
    final class ApplicationController: NSObject, NSApplicationDelegate {
        private let mch: ThreadChannel<MasterFlowControlSignal>
        init(masterChannel: ThreadChannel<MasterFlowControlSignal>) {
            mch = masterChannel
        }
        @objc
        @available(*, unavailable)
        func applicationDidFinishLaunching(_ aNotification: Notification) {
            mch.signal(.boot)
        }
        @objc
        @available(*, unavailable)
        func applicationWillTerminate(_ aNotification: Notification) {
            mch.signal(.term)
        }
    }

//    NSApplication.shared().mainMenu = mmc.menu
    let appcon = ApplicationController(masterChannel: masterFlowControlChannel)
    NSApplication.shared().delegate = appcon

    assert(Thread.isMainThread)
    exit(NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv))
}

private func workspaceFlow() {

}
