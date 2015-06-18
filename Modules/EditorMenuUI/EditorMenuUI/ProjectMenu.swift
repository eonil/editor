//
//  ProjectMenu.swift
//  EditorMenuUI
//
//  Created by Hoon H. on 2015/06/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph
import EditorModel

public class ProjectMenuController {
	
	public let	menu	=	NSMenu()
	
	public init() {
		menu.autoenablesItems	=	false
		menu.title		=	"Project"
		menu.allMenuItems	=	[
			run,
			test,
			documentate,
			benchmark,
			NSMenuItem.separatorItem(),
			build,
			clean,
			stop,
		]
	}
	deinit {
		assert(workspace == nil)
		assert(_has_workspace == false)
	}
	
	///	Set currently selected workspace here to reflect menu availability
	///	by the workspace.
	public weak var workspace: Workspace? {
		willSet {
			if let _ = workspace {
				_teardown()
				_has_workspace	=	false
			}
		}
		didSet {
			if let _ = workspace {
				_has_workspace	=	true
				_setup()
			}
		}
	}
	
	///	
	
	let	run		=	NSMenuItem(title: "Run", shortcut: Command+"r")
	let	test		=	NSMenuItem(title: "Test", shortcut: Command+"u")
	let	documentate	=	NSMenuItem(title: "Documentate", shortcut: None)
	let	benchmark	=	NSMenuItem(title: "Benchmark", shortcut: None)
	
	let	build		=	NSMenuItem(title: "Build", shortcut: Command+"b")
	let	clean		=	NSMenuItem(title: "Clean", shortcut: Command+Shift+"k")
	let	stop		=	NSMenuItem(title: "Stop", shortcut: Command+".")

	///
	
	private var	_has_workspace	=	false		//	This flag is required due to early nil-lization.
	private var	_channelings	:	AnyObject?
	
	private func _setup() {
		assert(_channelings == nil)
		
		func queueCargoCommand(cmd: Cargo.Command) -> ()->() {
			return	{ [weak self] in self?.workspace!.toolbox.cargo.queue(cmd) }
		}
		func executeDebuggerCommand(cmd: Debugger.Command) -> ()->() {
			return	{ [weak self] in self?.workspace!.debugger.execute(cmd) }
		}
		
		run.onAction		=	executeDebuggerCommand(.Launch)
		test.onAction		=	queueCargoCommand(.Test)
		documentate.onAction	=	queueCargoCommand(.Documentate)
		benchmark.onAction	=	queueCargoCommand(.Benchmark)
		build.onAction		=	queueCargoCommand(.Build)
		clean.onAction		=	queueCargoCommand(.Clean)
		stop.onAction		=	executeDebuggerCommand(.Halt)
		
		_channelings		=	[
			Channeling(workspace!.toolbox.cargo.availableCommands) 	{ [weak self] in self?._reconfigureForCargoCommands($0) },
			Channeling(workspace!.debugger.availableCommands) 	{ [weak self] in self?._reconfigureForDebuggerCommands($0) },
		]
	}
	private func _teardown() {
		assert(_channelings != nil)
		
		_channelings		=	nil
		
		for m in menu.allMenuItems {
			m.onAction	=	nil
		}
	}
	private func _reconfigureForCargoCommands(s: ValueSignal<Set<Cargo.Command>>) {
		clean.enabled		=	s.state?.contains(.Clean) ?? false
		build.enabled		=	s.state?.contains(.Build) ?? false
		run.enabled		=	s.state?.contains(.Run) ?? false
		documentate.enabled	=	s.state?.contains(.Documentate) ?? false
		test.enabled		=	s.state?.contains(.Test) ?? false
		benchmark.enabled	=	s.state?.contains(.Benchmark) ?? false
	}
	private func _reconfigureForDebuggerCommands(s: ValueSignal<Set<Debugger.Command>>) {
		run.enabled		=	s.state?.contains(.Launch) ?? false
		stop.enabled		=	s.state?.contains(.Halt) ?? false
	}
}

func weakly<T: AnyObject,U>(object: T, method: T->U->()) -> (U->()) {
	return	{ [weak object] parameters in
		if let object = object {
			return	method(object)(parameters)
		}
		//	No-op if `object` dead.
	}
}






