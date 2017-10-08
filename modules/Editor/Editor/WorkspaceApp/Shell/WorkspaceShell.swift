//
//  WorkspaceShell.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class WorkspaceShell {
    private typealias RS = Resources.Storyboard

    let main = NSWindowController(window: makeWindow())
    private let division = RS.division.instantiate()

    private let dialogueWatch = Relay<[DialogueFeature.Change]>()
    
    ///
    /// Designate feature to provides actual functionalities.
    /// Settings this to `nil` makes every user interaction
    /// no-op.
    ///
    weak var features: WorkspaceFeatures? {
        didSet {
            division.features = features
            features?.dialogue.changes += dialogueWatch
        }
    }

    init() {
        main.contentViewController = division
        main.window?.makeKeyAndOrderFront(self)
//        main.window?.appearance = NSAppearance(named: .vibrantDark)

        dialogueWatch.delegate = { [weak self] in self?.processDialogueChanges($0) }
    }

    private func processDialogueChanges(_ changes: [DialogueFeature.Change]) {
        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
        guard let window = main.window else { REPORT_missingIBOutletViewAndFatalError() }
        if let running = features.dialogue.state.running {
            switch running.alert {
            case .note(let n):
                MARK_unimplemented()
            case .query(let q):
                MARK_unimplemented()
            case .warning(let w):
                MARK_unimplemented()
            case .error(let e):
                let err = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(e)"])
                NSAlert(error: err).beginSheetModal(for: window, completionHandler: { (r) in
                })
            }
        }
        else {
            MARK_unimplemented()
        }
    }
//    ///
//    /// Idempotent.
//    /// No-op if there's no feature.
//    ///
//    private func connectToFeatures() {
//        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
//    }
//
//    ///
//    /// Idempotent.
//    /// No-op if there's no feature.
//    ///
//    private func disconnectFromFeatures() {
//        guard let features = features else { return REPORT_missingFeaturesAndContinue() }
//    }
}

private func makeWindow() -> NSWindow {
    let w = NSWindow()
    w.styleMask.formUnion([
        .resizable,
        .closable,
        .miniaturizable,
        ])
    return w
}
