////
////  AppDelegate.swift
////  Editor6
////
////  Created by Hoon H. on 2016/10/08.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Cocoa
//import LLDBWrapper
//import Editor6Common
//import Editor6MainMenuUI2
//
//final class Driver {
//    private static var instanceCount = 0
//    private let mmcon = MainMenuUI2Controller()
//    private let appcon = ApplicationController()
//    private let wsdman = WorkspaceDocumentManager()
//    private var localState = DriverState()
//
//    private let fileSaveAsFlow = Flow2<Driver>()
//
//    init() {
//        assert(Thread.isMainThread)
//        precondition(Driver.instanceCount == 0)
//        LLDBGlobals.initializeLLDBWrapper()
//        Driver.instanceCount += 1
//
//        NSApplication.shared().mainMenu = mmcon.menu
//        NSApplication.shared().delegate = appcon
//        mmcon.reload(localState.mainMenuUIState)
//
//        appcon.delegate = { [weak self] in self?.process(applicationControllerEvent: $0) }
//        mmcon.delegate { [weak self] in self?.process(mainMenuUI2Event: $0) }
//        wsdman.delegate = { [weak self] in self?.process(wsdmanEvent: $0) }
//
//        fileSaveAsFlow.context = self
//    }
//    func run() -> Int32 {
//        assert(Thread.isMainThread)
//        return NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
//    }
//    deinit {
//        assert(Thread.isMainThread)
//        NSApplication.shared().delegate = nil
//        NSApplication.shared().mainMenu = nil
//        Driver.instanceCount -= 1
//        LLDBGlobals.terminateLLDBWrapper()
//    }
//
//    private func process(applicationControllerEvent e: ApplicationController.Event) {
//        switch e {
//        case .didFinishLaunch:
//            // Nothing to do for now.
//            ()
//        case .willTerminate:
//            // Nothing to do for now.
//            ()
//        }
//    }
//    private func process(wsdmanEvent e: WorkspaceDocumentManager.Event) {
//        localState.apply(repoDocumentManagerEvent: e)
//        localState.apply(currentRepoState: wsdman.findCurrentWorkspaceDocument()?.repoController.state)
//        mmcon.reload(localState.mainMenuUIState)
//    }
//    private func process(mainMenuUI2Event e: MainMenuUI2Action) {
//        enum Cancel: Error {
//            case byPotentialBug(PotentialBug)
//        }
//        func runWithDefaultErrorHandling(_ f: () throws -> ()) {
//            do {
//                try f()
//            }
//            catch let c as Cancel {
//                switch c {
//                case .byPotentialBug(let pb):
//                    reportBugAndContinue(pb)
//                }
//            }
//            catch let e {
//                NSApplication.shared().presentError(e)
//            }
//        }
//        func runAsyncWithDefaultErrorHandling(_ f: @escaping () throws -> ()) {
//            do {
//                try f()
//            }
//            catch let c as Cancel {
//                switch c {
//                case .byPotentialBug(let pb):
//                    reportBugAndContinue(pb)
//                }
//            }
//            catch let e {
//                NSApplication.shared().presentError(e)
//            }
//        }
//        runWithDefaultErrorHandling {
//            func getCurrentDocumentIfAvailable() throws -> WorkspaceDocument {
//                guard let curdoc = wsdman.findCurrentWorkspaceDocument() else { throw Cancel.byPotentialBug(.mainMenuClickedWithNoCurrentWorkspaceDocument) }
//                return curdoc
//            }
//            switch e {
//            case .click(let menuItemID):
//                switch menuItemID {
//                case .applicationQuit:
//                    NSApplication.shared().terminate(self)
//                case .fileNewRepo:
//                    try NSDocumentController.shared().openUntitledDocumentAndDisplay(true)
//
////                case .fileNewWorkspace:
////                    let newDoc = try NSDocumentController.shared().makeUntitledDocument(ofType: "EonilEditor6Repo")
////                    let newdoc = try NSDocumentController.shared().openUntitledDocumentAndDisplay(true)
////                    guard let newdoc1 = newdoc as? WorkspaceDocument else { throw Cancel.byPotentialBug(.defaultNewDocumentIsNotWorkspaceDocument) }
//
//                case .fileOpen:
//                    NSDocumentController.shared().openDocument(nil)
////                    NSDocumentController.shared().beginOpenPanel(completionHandler: { us in
////                        guard let us = us else { return }
////                        for u in us {
////                            NSDocumentController.shared().openDocument(withContentsOf: u, display: true, completionHandler: { (_ d: NSDocument?, _: Bool, _ e: Error?) in
////                                runWithDefaultErrorHandling {
////                                    guard e == nil else { MARK_unimplemented() }
////                                    guard let newrlyOpenDoc = d as? WorkspaceDocument else { MARK_unimplemented() }
////                                    newrlyOpenDoc.repoController.process(RepoController.Command.relocate(u))
////                                }
////                            })
////                            debugLog(us)
////                        }
////                    })
//
//                case .fileSave:
//                    process(mainMenuUI2Event: .click(.fileSaveAs))
//
//                case .fileSaveAs:
//                    guard let curdoc = wsdman.findCurrentWorkspaceDocument() else { throw Cancel.byPotentialBug(.missingCurrentWorkspaceDocumentForRequiredContext) }
//                    fileSaveAsFlow.runSavePanelUI { u in
//                        runWithDefaultErrorHandling {
//                            curdoc.repoController.process(.relocate(u))
//                            try FileManager.default.createDirectory(at: u, withIntermediateDirectories: true, attributes: nil)
//                            guard let repoName = u.editor6_makeRepoName() else { throw Cancel.byPotentialBug(.badRepoNameWhichHasNoVisibleNamePart) }
//                            let repoSpecFileURL = u.appendingPathComponent(repoName).appendingPathExtension("ee6repo1spec1")
//                            try Data().write(to: repoSpecFileURL)
//                            curdoc.repoController.process(.init)
//                        }
//                    }
//
//                case .fileCloseRepo:
//                    guard let curdoc = wsdman.findCurrentWorkspaceDocument() else { throw Cancel.byPotentialBug(PotentialBug.mainMenuClickedWithNoCurrentWorkspaceDocument) }
//                    curdoc.close()
//
//                case .productClean:
//                    let curdoc = try getCurrentDocumentIfAvailable()
//                    curdoc.repoController.process(.clean)
//                case .productBuild:
//                    let curdoc = try getCurrentDocumentIfAvailable()
//                    curdoc.repoController.process(.build)
////                case .productRun:
//                default:
//                    MARK_unimplemented()
//                }
//            }
//        }
//    }
//}
//
//
//
//
//
//
/////
///// I don't trust `NSDocumentController`'s synchronization timing.
///// That's why this manager exists.
/////
//@objc
//private final class ApplicationController: NSObject, NSApplicationDelegate {
//    var delegate: ((Event) -> ())?
//    enum Event {
//        case didFinishLaunch
//        case willTerminate
//    }
//
//    @objc
//    @available(*, unavailable)
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        delegate?(.didFinishLaunch)
//    }
//    @objc
//    @available(*, unavailable)
//    func applicationWillTerminate(_ aNotification: Notification) {
//        delegate?(.willTerminate)
//    }
//
//    @objc
//    @available(*, unavailable)
//    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
//        // Allows to make only-in-memory repo.
//        return true
//    }
//}
//
//
//
//
//
