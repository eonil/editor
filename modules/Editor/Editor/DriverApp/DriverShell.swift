//
//  DriverShell.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit
import EonilSignet

final class DriverShell {
    private let mainMenuController = MainMenu2Controller()
    private let mainMenuWatch = Relay<MainMenu2Controller.Event>()
    private var mainMenuState = MainMenu2State()

    private let dialogueWatch = Relay<Void>()

    ///
    /// Designate feature to provides actual functionalities.
    /// Settings this to `nil` makes every user interaction
    /// no-op.
    ///
    weak var features: DriverFeatures? {
        willSet {
            disconnectFromFeatures()
        }
        didSet {
            connectToFeatures()
        }
    }

    init() {
        mainMenuState.availableItems.insert(.appQuit)
        mainMenuState.availableItems.formUnion([
            .testdriveMakeRandomFiles,
            .testdriveMakeWorkspace,
            .appQuit,
            .fileNewWorkspace,
            .fileNewFolder,
            .fileNewFile,
            .fileOpen,
            .fileCloseWorkspace,
            ])
        mainMenuController.reload(mainMenuState)
        NSApplication.shared().mainMenu = mainMenuController.menu
        mainMenuWatch.delegate = { [weak self] in self?.processMainMenuEvent($0) }
        mainMenuWatch.watch(mainMenuController.event)
    }

    private func processMainMenuEvent(_ e: MainMenu2Controller.Event) {
        guard let features = features else { return }
        switch e {
        case .click(let id):
            switch id {
            case .testdriveMakeWorkspace:
                let u = URL(fileURLWithPath: "/Users/Eonil/Temp/t3/t111")
                features.makeWorkspaceDirectiry(at: u)

            case .appQuit:
                NSApplication.shared().terminate(self)

            case .fileNewWorkspace:
//                NSDocumentController.shared().newDocument(self)
                let sp = NSSavePanel()
                let r = sp.runModal()
                guard r == NSFileHandlingPanelOKButton else { return }
                if let u = sp.url {
                    let u1 = features.fixWorkspaceDirectoryURL(u)
                    features.makeWorkspaceDirectiry(at: u1)
                    NSDocumentController.shared().openDocument(withContentsOf: u1, display: true, completionHandler: { _ in })
                }


            case .fileOpen:
                NSDocumentController.shared().openDocument(nil)

            case .fileCloseWorkspace:
                AUDIT_check(WorkspaceDocument.current != nil)
                WorkspaceDocument.current?.close()

            default:
                break
            }

            WorkspaceDocument.current?.process(id)
        }
    }

    ///
    /// Idempotent.
    /// No-op if there's no feature.
    ///
    private func connectToFeatures() {
        guard let features = features else { return }
        features
    }

    ///
    /// Idempotent.
    /// No-op if there's no feature.
    ///
    private func disconnectFromFeatures() {
        guard let features = features else { return }
    }
}
