//
//  AppDelegate.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Cocoa
import LLDBWrapper
import Editor6MainMenuUI2

final class Driver {
    private static var instanceCount = 0
    private let mmc = MainMenuUI2Controller()
    private let appcon = ApplicationController()
    private var localState = DriverState()

    init() {
        assert(Thread.isMainThread)
        precondition(Driver.instanceCount == 0)
        LLDBGlobals.initializeLLDBWrapper()
        Driver.instanceCount += 1
        mmc.delegate { [weak self] in self?.process($0) }
        mmc.reload(localState.mainMenu)
        appcon.owner = self
        NSApplication.shared().mainMenu = mmc.menu
        NSApplication.shared().delegate = appcon
        Driver.queue = { [weak self] in self?.schedule(.handle($0)) }
    }
    func run() -> Int32 {
        assert(Thread.isMainThread)
        return NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
    deinit {
        assert(Thread.isMainThread)
        Driver.queue = ignore
        NSApplication.shared().delegate = nil
        NSApplication.shared().mainMenu = nil
        appcon.owner = nil
        Driver.instanceCount -= 1
        LLDBGlobals.terminateLLDBWrapper()
    }

    // MARK: -

    /// In AppKit, each `NSDocument`s are independently created and destroyed
    /// and there's no existing facility to track thier creation and destruction
    /// from other place. They seem to be intended to be independent islands.
    /// I had to create a message channel, and this is that channel.
    ///
    /// Named as `dispatch` because this will not
    static private(set) var queue: (WorkspaceMessage) -> () = ignore

    /// Steps single iteration of loop.
    /// There's no explicit loop.
    /// Dispatched actions from each terminal view components
    /// will be enqueued and trigger async event consumption function.
    /// The consumption function is this.
    ///
    private func process(_ command: Command) {
        switch command {
        case .handle(let workspaceMessage):
            localState.apply(event: workspaceMessage)
        }

        mmc.reload(localState.mainMenu)
        let m = DriverMessage.change(localState)
        NSDocumentController.shared().documents
            .flatMap { $0 as? WorkspaceDocument }
            .forEach { $0.process(message: m) }
    }
    fileprivate func schedule(_ command: Command) {
        assert(Thread.isMainThread)
        // Restart if needed.
        do {
            // An action is output of processing.
            // It becomes input command of next iteration.
            // Async dispatch triggers loop iteration.
            // 
            // Why Do We Need This?
            // --------------------
            // To avoid immediate re-entering.
            // Action processing can ultimately trigger another action.
            // And the second action can trigger first action again.
            // Then it becomes infinite loop.
            // And it's very hard to prevent such loop because they are
            // sent from terminal view components.
            DispatchQueue.main.async { [weak self] in self?.process(command) }
        }
    }

    private func process(_ action: MainMenuUI2Action) {
        do {
            switch action {
            case .click(let menuItemID):
                switch menuItemID {
                case .applicationQuit:
                    NSApplication.shared().terminate(self)
                case .fileNewWorkspace:
                    try NSDocumentController.shared().makeUntitledDocument(ofType: "EonilEditor6Workspace")
                default:
                    MARK_unimplemented()
                }
            }
        }
        catch let error {
            NSApplication.shared().presentError(error)
        }
    }
}

private enum Command {
//    case ADHOC_test
    case handle(WorkspaceMessage)
}


private final class ApplicationController: NSObject, NSApplicationDelegate {
    weak var owner: Driver?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        owner?.schedule(.ADHOC_test)
    }
    func applicationWillTerminate(_ aNotification: Notification) {
    }
}
