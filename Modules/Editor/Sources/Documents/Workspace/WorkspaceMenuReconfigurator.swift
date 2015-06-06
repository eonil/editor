////
////  WorkspaceMenuReconfigurator.swift
////  Editor
////
////  Created by Hoon H. on 2015/06/03.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import SignalGraph
//import EditorModel
//
//class WorkspaceMenuReconfigurator {
//	let	workspace	:	Workspace
//	
//	init(workspace: Workspace) {
//		self.workspace		=	workspace
//		
////		_cargoCommandWatch.handler = { [weak self] (s: ValueSignal<Set<Cargo.Command>>)->() in
////			switch s {
////			case .Initiation(let s):
////				DefaultMenuControllerPalette.project.reconfigureWithModelState(s())
////				
////			case .Transition(let s):
////				DefaultMenuControllerPalette.project.reconfigureWithModelState(s())
////				
////			case .Termination(let s):
////				DefaultMenuControllerPalette.project.reconfigureWithModelState(s())
////				
////			}
////		}
////		
////		_debuggerCommandWatch.handler = { [weak self] (s: ValueSignal<Set<Debugger.Command>>)->() in
////			switch s {
////			case .Initiation(let s):
////				DefaultMenuControllerPalette.debug.reconfigureWithModelState(s())
////
////			case .Transition(let s):
////				DefaultMenuControllerPalette.debug.reconfigureWithModelState(s())
////				
////			case .Termination(let s):
////				DefaultMenuControllerPalette.debug.reconfigureWithModelState(s())
////				
////			}
////		}
//		
//		workspace.toolbox.cargo.availableCommands.emitter.register(_cargoCommandWatch)
//		workspace.debugger.availableCommands.emitter.register(_debuggerCommandWatch)
//	}
//	deinit {
//		workspace.debugger.availableCommands.emitter.deregister(_debuggerCommandWatch)
//		workspace.toolbox.cargo.availableCommands.emitter.deregister(_cargoCommandWatch)
//	}
//	
//	private let	_cargoCommandWatch	=	SignalMonitor<ValueSignal<Set<Cargo.Command>>>()
//	private let	_debuggerCommandWatch	=	SignalMonitor<ValueSignal<Set<Debugger.Command>>>()
//}
//
//
//
//
//
//
//
