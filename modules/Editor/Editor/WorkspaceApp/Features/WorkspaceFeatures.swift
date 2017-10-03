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

            case .project(let cmd):
                project.process(cmd)

            case .codeEditing(let cmd):
                let cmds = codeEditing.process(cmd)
                cmdq.append(contentsOf: cmds)

            case .build(let cmd):
                let cmds = build.process(cmd)
                cmdq.append(contentsOf: cmds)

            case .spawn(let proc):
                switch proc {
                case .moveFile(let from, let to):
                    switch project.moveFile(from: from, to: to) {
                    case .failure(let issue):
                        dialogue.process(.spawn(.error(DialogueFeature.Error.ADHOC_any("\(issue)"))))
                    case .success(_):
                        break
                    }
                case .renameFile(let at, let with):
                    let r = project.renameFile(at: at, with: with)
                    switch r {
                    case .failure(let issue):
                        dialogue.process(.spawn(.error(DialogueFeature.Error.ADHOC_any("\(issue)"))))
                    case .success(_):
                        break
                    }
                }
            }
        }
    }

    private func processMenuMenuItem(_ c: MainMenuItemID) {
        switch c {
        case .testdriveMakeRandomFiles:
            if project.state.files.count > 0 {
                let psel = ProjectSelection(snapshot: ProjectFeature.FileTree(node: .root), indexPaths: AnySequence([[]]))
                project.process(.setSelection(to: psel))
                project.process(.deleteSelectedFiles)
            }
            project.makeFile(at: [], as: .folder)
            project.makeFile(at: [0], as: .folder)
            project.makeFile(at: [1], as: .folder)
            project.makeFile(at: [2], as: .folder)
            project.makeFile(at: [3], as: .folder)

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
                project.makeFile(at: idxp, as: .folder)
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
                try! project.makeFile(at: idxp, as: .file)
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

        case .debugClearConsole:
            log.process(.startSession(.editing))

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
