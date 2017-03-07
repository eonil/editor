//
//  RepoController.swift
//  Editor6
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import Editor6Common
import Editor6WorkspaceModel
import Editor6MainMenuUI2
import Editor6WorkspaceUI

final class RepoController {
    private let model = RepoModel()
    private let projectTreeController = RepoProjectTreeController()
    private let view = WorkspaceUIWindowController()
    private var viewState = WorkspaceUIState()
    var delegate: ((Event) -> ())?

    enum Command {
        case relocate(URL)
        case `init`
        case clean
        case build
        case run
        case halt
    }
    enum Event {
        case stateChange
    }

    init() {
        model.delegate = { [weak self] in self?.process(modelEvent: $0) }
        view.delegate = {  [weak self] in self?.process(viewEvent: $0) }
    }
    deinit {

    }

    var state: RepoState {
        return model.state
    }
    var windowController: NSWindowController {
        return view
    }
    func process(_ command: Command) {
        switch command {
        case .relocate(let u):
            model.queue(.relocate(u))
        case .init:
            model.queue(.init)
        case .clean:
            model.queue(.product(.clean))
        case .build:
            model.queue(.product(.build))
        case .run:
            MARK_unimplemented()
        case .halt:
            MARK_unimplemented()
        }
    }
    private func process(modelEvent e: RepoEvent) {
        switch e {
        case .mutateIssues(let m):
            switch m {
            case .insert(let r, let es):
                // FIXME: Implement this properly.
                MARK_poorlyImplemented()
                for i in 0..<r.count {
                    let insertingIndex = r.lowerBound + i
                    let insertingElement = es[i]
                    var s = WorkspaceUIBasicOutlineNodeState()
                    s.label = "\(insertingElement)"
                    let parentNodeID = viewState.navigator.issues.tree.root.id
                    viewState.navigator.issues.tree.insert(s, at: insertingIndex, in: parentNodeID)
                }
                view.reload(viewState)

            case .update(let r, let es):
                MARK_unimplemented()
            case .delete(let r, let es):
                MARK_unimplemented()
            }
        case .mutateProject(let m):
            projectTreeController.apply(m)
        case .ADHOC_changeAnythingElse:
            MARK_unimplementedButSkipForNow()
        }
    }
    private func process(viewEvent e: WorkspaceUIAction) {
        MARK_unimplementedButSkipForNow()
    }
}
