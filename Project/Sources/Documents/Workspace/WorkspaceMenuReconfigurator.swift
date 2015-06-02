//
//  WorkspaceMenuReconfigurator.swift
//  Editor
//
//  Created by Hoon H. on 2015/06/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph
import EditorModel

class WorkspaceMenuReconfigurator {
	let	workspace	:	Workspace
	
	init(workspace: Workspace) {
		self.workspace		=	workspace
		_commandWatch.handler	=	{ [weak self] (s: ValueSignal<Set<Debugger.Command>>)->() in
			switch s {
			case .Initiation(let s):
				DefaultMenuControllerPalette.debug.reconfigureWithModelState(s())

			case .Transition(let s):
				DefaultMenuControllerPalette.debug.reconfigureWithModelState(s())
				
			case .Termination(let s):
				DefaultMenuControllerPalette.debug.reconfigureWithModelState(s())
				
			}
		}
		workspace.debugger.availableCommands.emitter.register(_commandWatch)
	}
	
	private let	_commandWatch	=	SignalMonitor<ValueSignal<Set<Debugger.Command>>>()
}