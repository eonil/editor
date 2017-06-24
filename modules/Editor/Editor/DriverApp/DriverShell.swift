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
            .appQuit,
            .fileNewWorkspace,
            .fileNewFolder,
            .fileNewFile,
            .fileClose,
            ])
        mainMenuController.reload(mainMenuState)
        NSApplication.shared().mainMenu = mainMenuController.menu
        mainMenuWatch.delegate = { [weak self] in self?.processMainMenuEvent($0) }
        mainMenuWatch.watch(mainMenuController.event)
    }

    private func processMainMenuEvent(_ e: MainMenu2Controller.Event) {
        switch e {
        case .click(let id):
            switch id {
            case .appQuit:
                NSApplication.shared().terminate(self)
            case .fileNewWorkspace:
                NSDocumentController.shared().newDocument(self)
            default:
                break
            }

            AUDIT_check(WorkspaceDocument.current != nil,
                        ["Bad main-menu management.",
                         "No current workspace document ",
                         "for dispatched main menu command."].joined())
            WorkspaceDocument.current?.process(id)
        }
    }

    ///
    /// Idempotent.
    /// No-op if there's no feature.
    ///
    private func connectToFeatures() {
        guard let features = features else { return }
    }

    ///
    /// Idempotent.
    /// No-op if there's no feature.
    ///
    private func disconnectFromFeatures() {
        guard let features = features else { return }
    }
}
