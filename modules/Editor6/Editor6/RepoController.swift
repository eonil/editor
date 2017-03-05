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
}
