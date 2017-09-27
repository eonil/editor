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
    private let buildWatch = Relay<[BuildFeature.Change]>()
    let plan = PlanFeature()
    let navigation = NavigationFeature()
    let dialogue = DialogueFeature()
    let project = ProjectFeature()
    let codeEditing = CodeEditingFeature()
    let autoCompletion = AutoCompletionFeature()
    let scene = SceneFeature()
    let build = BuildFeature()
    let debug = DebugFeature()
    let log = LogFeature()
    private var cmdq = [WorkspaceCommand]()

    init() {
        loop.step = { [weak self] in self?.step() }
        watch.delegate = { [weak self] _ in self?.loop.signal() }
        buildWatch.delegate = { [weak self] _ in self?.loop.signal()  }
        project.signal += watch
        build.changes += buildWatch
    }

    func process(_ cmd: WorkspaceCommand) {
        processSequence([cmd])
    }
    func processSequence(_ cmds: [WorkspaceCommand]) {
        cmdq.append(contentsOf: cmds)
        step()
    }
    private func step() {
        build.setProjectState(project.state)
        log.process(.setBuildState(build.state))

        while let cmd = cmdq.removeFirstIfAvailable() {
            switch cmd {
            case .menu(let id):
                processMenuMenuItem(id)

            case .plan(let cmd):
                let cmds = plan.process(cmd)
                cmdq.append(contentsOf: cmds)

            case .dialogue(let cmd):
                let cmds = dialogue.process(cmd)
                cmdq.append(contentsOf: cmds)

            case .codeEditing(let cmd):
                let cmds = codeEditing.process(cmd)
                cmdq.append(contentsOf: cmds)

            case .build(let cmd):
                let cmds = build.process(cmd)
                cmdq.append(contentsOf: cmds)
            }
        }
    }

    private func processMenuMenuItem(_ c: MainMenuItemID) {
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

        case .fileClose:
            codeEditing.process(.close)

        case .productClean:
            build.process(.cleanAll)

        case .productBuild:
            build.process(.build)

        case .productRun:
            processSequence([
                .plan(.queueTask(.buildLaunch)),
                .plan(.queueTask(.buildWaitForCompletion)),
                .plan(.queueTask(.debugLaunch))
                ])

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
