//
//  Driver2.swift
//  Editor6
//
//  Created by Hoon H. on 2017/06/11.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Editor6Services
import Editor6Features
import Editor6Shell

final class Driver2 {
    private let appDelegateProxy: AppDelegateProxy
    private let workspaceDocumentManager: WorkspaceDocumentManager

    private let services: Services
    private let features: AppDriverFeatures
    private let shell: AppDriverShell

    init() {
        appDelegateProxy = AppDelegateProxy()
        workspaceDocumentManager = WorkspaceDocumentManager()
        services = Services()
        shell = AppDriverShell()
        features = AppDriverFeatures()

        features.services = services
        shell.features = features
        appDelegateProxy.event = { [weak self] in self?.processApplicationEvent($0) }
        workspaceDocumentManager.delegate = { [weak self] in self?.processWorkspaceDocumentManagerEvent($0) }
        NSApplication.shared().delegate = appDelegateProxy
    }
    deinit {
        features.services = nil
        shell.features = nil
        NSApplication.shared().delegate = nil
        appDelegateProxy.event = nil
    }
    ///
    /// - Returns:
    ///     An exit code.
    ///
    func run() -> Int32 {
        assert(Thread.isMainThread)
        return NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }

    private func processApplicationEvent(_ e: ApplicationEvent) {
        switch e {
        case .didFinishLaunching:
            break
        }
    }
    private func processWorkspaceDocumentManagerEvent(_ e: WorkspaceDocumentManager.Event) {
        switch e {
        case .didAddDocument(let wdoc):
            wdoc.services = services
        case .willRemoveDocument(let wdoc):
            wdoc.services = nil
        case .changeCurrentDocument:
            break
        case .changeState(let wdoc):
            break
        }
    }
}



import AppKit
private extension Driver2 {
    enum ApplicationEvent {
        case didFinishLaunching
    }
    final class AppDelegateProxy: NSObject, NSApplicationDelegate {
        var event: ((ApplicationEvent) -> Void)?
        func applicationDidFinishLaunching(_ notification: Notification) {
            assert(event != nil)
            event?(.didFinishLaunching)
        }
    }
}
