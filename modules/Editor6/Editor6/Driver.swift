//
//  AppDelegate.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Cocoa

final class Driver {
    private static var instanceCount = 0
    private let appdel = ApplicationDelegate()
    private let mmm = MainMenuManager()
    private var localState = DriverState()

    init() {
        precondition(Driver.instanceCount == 0)
        Driver.instanceCount += 1
        appdel.owner = self
        NSApplication.shared().delegate = appdel
        Driver.dispatch = { [weak self] in self?.schedule(.handle($0)) }
    }
    func run() -> Int32 {
        return NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
    deinit {
        Driver.dispatch = noop
        NSApplication.shared().delegate = nil
        appdel.owner = nil
        Driver.instanceCount -= 1
    }

    // MARK: -

    /// In AppKit, each `NSDocument`s are independently created and destroyed
    /// and there's no existing facility to track thier creation and destruction
    /// from other place. They seem to be intended to be independent islands.
    /// I had to create a message channel, and this is that channel.    
    static private(set) var dispatch: (_ event: WorkspaceDocumentEvent) -> () = noop

    /// Steps single iteration of loop.
    /// There's no explicit loop.
    /// Dispatched actions from each terminal view components
    /// will be enqueued and trigger async event consumption function.
    /// The consumption function is this.
    ///
    private func execute(_ command: Command) {
        switch command {
        case .ADHOC_test:
            for doc in NSDocumentController.shared().documents {
                doc.close()
            }
            NSDocumentController.shared().newDocument(self)
        case .handle(let workspaceEvent):
            localState.apply(event: workspaceEvent)
        }
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
            // To avoid re-entering.
            // Action processing can ultimately trigger another action.
            // And the second action can trigger first action again.
            // Then it becomes infinite loop.
            // And it's very hard to prevent such loop because they are
            // sent from terminal view components.
            DispatchQueue.main.async { [weak self] in self?.execute(command) }
        }
    }
}

private enum Command {
    case ADHOC_test
    case handle(WorkspaceDocumentEvent)
}


private final class ApplicationDelegate: NSObject, NSApplicationDelegate {
    weak var owner: Driver?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        owner?.schedule(.ADHOC_test)
    }
    func applicationWillTerminate(_ aNotification: Notification) {
    }
}

private func noop<T>(_: T) {
}
