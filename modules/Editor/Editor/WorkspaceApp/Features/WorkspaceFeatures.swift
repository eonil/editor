//
//  WorkspaceFeatures.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class WorkspaceFeatures {
    let navigation = NavigationFeature()
    let project = ProjectFeature()
    let autoCompletion = AutoCompletionFeature()
    let scene = SceneFeature()
    let build = BuildFeature()
    let debug = DebugFeature()
    let log = LogFeature()
    
    weak var services: WorkspaceServices? {
        didSet { connectToServices() }
        willSet { disconnectFromServices() }
    }

    ///
    /// Idempotent.
    /// No-op if `services == nil`.
    ///
    private func connectToServices() {
        guard let services = services else { return }
        project.services = services
        build.services = services
        debug.services = services
        log.services = services
    }

    ///
    /// Idempotent.
    /// No-op if `services == nil`.
    ///
    private func disconnectFromServices() {
//        guard let services = services else { return }
        project.services = nil
        build.services = nil
        debug.services = nil
        log.services = nil
    }
}
