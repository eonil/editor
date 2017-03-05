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
    }
    deinit {

    }

    var state: RepoState {
        return model.state
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
                    let id = WorkspaceUIBasicOutlineNodeID()
                    var s = WorkspaceUIBasicOutlineNodeState()
                    s.label = "\(insertingElement)"
                    viewState.navigator.issues.tree//.insert((id, s), at: insertingIndex, in: viewState.navigator.issues.tree.root)
                }

            case .update(let r, let es):
                viewState
            case .delete(let r, let es):
                viewState
            }
        }
    }
}
