//
//  WorkspaceFeatures.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

final class WorkspaceFeatures: ServicesDependent {
    private let loop = ManualLoop()
    private let watch = Relay<()>()
    let navigation = NavigationFeature()
    let dialogue = DialogueFeature()
    let project = ProjectFeature()
    let autoCompletion = AutoCompletionFeature()
    let scene = SceneFeature()
    let build = BuildFeature()
    let debug = DebugFeature()
    let log = LogFeature()

    init() {
        loop.step = { [weak self] in self?.step() }
        watch.delegate = { [weak self] _ in self?.loop.signal() }
        project.signal += watch
        build.change += watch
    }
    
    private func step() {
        log.process(build.production)
//        build.clear()
        build.setProjectState(project.state)
    }

    func process(_ c: MainMenuItemID) {
        switch c {
        case .testdriveMakeRandomFiles:
            if project.state.files.count > 0 {
                project.deleteFiles(at: [.root])
            }
            typealias IndexPath = ProjectFeature.FileTree.IndexPath
            let r = IndexPath.root
            project.makeFile(at: r, content: .folder)
            project.makeFile(at: r.appendingLastComponent(0), content: .folder)
            project.makeFile(at: r.appendingLastComponent(1), content: .folder)
            project.makeFile(at: r.appendingLastComponent(2), content: .folder)
            project.makeFile(at: r.appendingLastComponent(3), content: .folder)

        case .testdriveMakeWorkspace:
            break

        case .appQuit:
            break

        case .fileNewWorkspace:
            break

        case .fileNewFolder:
            // Make a new node right under the current selection.
            switch project.findInsertionPointForNewNode() {
            case .failure(let reason):
                let underlyingReason = [
                    "Received menu command `\(c)`,",
                    "and could not find an insertion point.",
                    "Ignored.",
                ].joined(separator: " ")
                let allReason = [underlyingReason, reason,].joined(separator: "\n")
                REPORT_recoverableWarning(allReason)
            case .success(let insertionPointIndexPath):
                let idxp = insertionPointIndexPath
                project.makeFile(at: idxp, content: .folder)
            }

        case .fileNewFile:
            // Make a new node right under the current selection.
            switch project.findInsertionPointForNewNode() {
            case .failure(let reason):
                let underlyingReason = [
                    "Received menu command `\(c)`,",
                    "and could not find an insertion point.",
                    "Ignored.",
                    ].joined(separator: " ")
                let allReason = [underlyingReason, reason,].joined(separator: "\n")
                REPORT_recoverableWarning(allReason)
            case .success(let insertionPointIndexPath):
                let idxp = insertionPointIndexPath
                project.makeFile(at: idxp, content: .file)
                let (path, _) = project.state.files[idxp]!
                // Make actual directory.
                let u = project.makeFileURL(for: path)!
                try? makeEmptyData().write(to: u)
            }

        case .fileOpen:
            break

        case .productClean:
            build.process(.cleanAll)

        case .productBuild:
            build.process(.build)

        default:
            REPORT_recoverableWarning("Processing unimplemented menu command... `\(c)`.")
            MARK_unimplementedButSkipForNow()
        }
    }
}

import Foundation
private func makeEmptyData() -> Data {
    return Data()
}
