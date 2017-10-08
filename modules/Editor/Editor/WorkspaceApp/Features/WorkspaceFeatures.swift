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

        func queueCommands(_ commands: [WorkspaceCommand]) {
            cmdq.append(contentsOf: commands)
            step()
        }
        func spawnErrorDialogue(with issue: WorkspaceIssue) {
            queueCommands([.dialogue(.spawn(.error(.workspace(issue))))])
        }

        while let cmd = cmdq.removeFirstIfAvailable() {
            switch cmd {
            case .menu(let id):
                processMenuMenuItem(id)

            case .plan(let cmd):
                switch plan.process(cmd) {
                case .failure(let issue):   spawnErrorDialogue(with: .plan(issue))
                case .success(let cmds):    queueCommands(cmds)
                }

            case .dialogue(let cmd):
                switch dialogue.process(cmd) {
                case .failure(let issue):   REPORT_criticalBug("A dialogue could not be presented: \(issue)")
                case .success(_):           break
                }

            case .project(let cmd):
                switch project.process(cmd) {
                case .failure(let issue):   spawnErrorDialogue(with: .project(issue))
                case .success(_):           break
                }

            case .codeEditing(let cmd):
                switch codeEditing.process(cmd) {
                case .failure(let issue):   spawnErrorDialogue(with: .codeEditing(issue))
                case .success(_):           break
                }

            case .editSelectedFile:
                let selection = project.state.selection
                guard selection.count == 1 else { break }
                let idxp = Array(selection)[0]
                // Ignore non-file entries...
                guard project.state.files[idxp].node.kind == .file else { break }
                // Ignore if final location cannot be resolved...
                guard let fileURL = project.state.makeLocationOnFileSystemForFile(at: idxp).successValue else { break }
                process(.codeEditing(.open(fileURL)))

            case .saveAndBuild(let cmd):
                process(.codeEditing(.saveIfNeeded))
                switch build.process(cmd) {
                case .failure(let issue):   spawnErrorDialogue(with: .build(issue))
                case .success(_):           break
                }
            }
        }
    }

    private func processMenuMenuItem(_ c: MainMenuItemID) {
        switch c {
        case .testdriveMakeRandomFiles:
            if project.state.files.count > 0 {
                let newSelection = project.makeSelection(with: [])
                project.process(.setSelection(to: newSelection)).successValue!
                project.process(.deleteSelectedFiles).successValue!
            }
            process(.project(.makeFile(at: [], as: .folder)))
            process(.project(.makeFile(at: [0], as: .folder)))
            process(.project(.makeFile(at: [1], as: .folder)))
            process(.project(.makeFile(at: [2], as: .folder)))
            process(.project(.makeFile(at: [3], as: .folder)))

        case .testdriveMakeWorkspace:   break // This MUST already been handled in driver-app.
        case .appQuit:                  break // This MUST already been handled in driver-app.
        case .fileNewWorkspace:         break // This MUST already been handled in driver-app.
        case .fileNewFolder:            process(.project(.makeFileAtInferredPosition(as: .file)))
        case .fileNewFile:              process(.project(.makeFileAtInferredPosition(as: .folder)))
        case .fileOpen:                 break // This MUST already been handled in driver-app.
        case .fileClose:                process(.codeEditing(.close))
        case .productClean:             process(.saveAndBuild(.cleanAll))
        case .productBuild:             process(.saveAndBuild(.build))

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
            MARK_unimplementedButSkipForNow(Void())
        }
    }
}

import Foundation
private func makeEmptyData() -> Data {
    return Data()
}
