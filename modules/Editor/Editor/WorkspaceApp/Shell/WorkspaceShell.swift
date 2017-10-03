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
    
    ///
    /// Designate feature to provides actual functionalities.
    /// Settings this to `nil` makes every user interaction
    /// no-op.
    ///
    weak var features: WorkspaceFeatures? {
        didSet {
            division.features = features
        }
    }

    init() {
        main.contentViewController = division
        main.window?.makeKeyAndOrderFront(self)
//        main.window?.appearance = NSAppearance(named: .vibrantDark)
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
