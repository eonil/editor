//
//  WorkspaceFeatures.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class WorkspaceFeatures: ServiceDependent {
    let navigation = NavigationFeature()
    let project = ProjectFeature()
    let autoCompletion = AutoCompletionFeature()
    let scene = SceneFeature()
    let build = BuildFeature()
    let debug = DebugFeature()
    let log = LogFeature()

    func process(_ c: MainMenuItemID) {
        switch c {
        case .testdriveMakeRandomFiles:
            if project.state.files.count > 0 {
                project.deleteNode(at: .root)
            }
            typealias IndexPath = ProjectFeature.FileTree.IndexPath
            let r = IndexPath.root
            project.makeNode(at: r, content: .folder)
            project.makeNode(at: r.appendingLastComponent(0), content: .folder)
            project.makeNode(at: r.appendingLastComponent(1), content: .folder)
            project.makeNode(at: r.appendingLastComponent(2), content: .folder)
            project.makeNode(at: r.appendingLastComponent(3), content: .folder)
        }
    }
}
