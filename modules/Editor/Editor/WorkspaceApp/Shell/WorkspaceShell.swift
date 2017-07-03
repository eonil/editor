//
//  WorkspaceShell.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class WorkspaceShell {
    let windowController = WorkspaceWindowController()

    ///
    /// Designate feature to provides actual functionalities.
    /// Settings this to `nil` makes every user interaction
    /// no-op.
    ///
    weak var features: WorkspaceFeatures? {
        willSet {
//            disconnectFromFeatures()
        }
        didSet {
//            connectToFeatures()
            windowController.features = features
        }
    }

//    ///
//    /// Idempotent.
//    /// No-op if there's no feature.
//    ///
//    private func connectToFeatures() {
//        guard let features = features else { return }
//    }
//
//    ///
//    /// Idempotent.
//    /// No-op if there's no feature.
//    ///
//    private func disconnectFromFeatures() {
//        guard let features = features else { return }
//    }
}
