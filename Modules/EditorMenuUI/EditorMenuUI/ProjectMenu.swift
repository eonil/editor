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
		assert(_isConnected == false)
	}
	
	///	Set currently selected workspace here to reflect menu availability
	///	by the workspace.
	public weak var workspace: Workspace? {
		willSet {
			if workspace != nil {
				_disconnect()
			}
		}
		didSet {
			if workspace != nil {
				_connect()
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

	private let	_cargoCommandAvailabilityMonitor	=	SetMonitor<Cargo.Command>()
	private let	_debuggerCommandAvailabiltiyMonitor	=	SetMonitor<Debugger.Command>()
	private var	_isConnected				=	false
	
	private func _connect() {
		assert(workspace != nil)
		assert(_isConnected == false)

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

		_cargoCommandAvailabilityMonitor.didBegin	=	{ [weak self] in self!._onBeginCargoCommandState($0) }
		_cargoCommandAvailabilityMonitor.willEnd	=	{ [weak self] in self!._onEndCargoCommandState($0) }
		_debuggerCommandAvailabiltiyMonitor.didBegin	=	{ [weak self] in self!._onBeginDebuggerCommandState($0) }
		_debuggerCommandAvailabiltiyMonitor.willEnd	=	{ [weak self] in self!._onEndDebuggerCommandState($0) }

		workspace!.toolbox.cargo.availableCommands.register(_cargoCommandAvailabilityMonitor)
		workspace!.debugger.availableCommands.register(_debuggerCommandAvailabiltiyMonitor)

		_isConnected	=	true
	}
	private func _disconnect() {
		assert(workspace != nil)
		assert(_isConnected == false)

		workspace!.debugger.availableCommands.deregister(_debuggerCommandAvailabiltiyMonitor)
		workspace!.toolbox.cargo.availableCommands.deregister(_cargoCommandAvailabilityMonitor)

		_cargoCommandAvailabilityMonitor.didBegin	=	nil
		_cargoCommandAvailabilityMonitor.willEnd	=	nil
		_debuggerCommandAvailabiltiyMonitor.didBegin	=	nil
		_debuggerCommandAvailabiltiyMonitor.willEnd	=	nil

		for m in menu.allMenuItems {
			m.onAction	=	nil
		}

		_isConnected	=	false
	}

	private func _onBeginCargoCommandState(state: Set<Cargo.Command>) {
		clean.enabled		=	state.contains(.Clean) ?? false
		build.enabled		=	state.contains(.Build) ?? false
		run.enabled		=	state.contains(.Run) ?? false
		documentate.enabled	=	state.contains(.Documentate) ?? false
		test.enabled		=	state.contains(.Test) ?? false
		benchmark.enabled	=	state.contains(.Benchmark) ?? false
	}
	private func _onEndCargoCommandState(state: Set<Cargo.Command>) {
		clean.enabled		=	false
		build.enabled		=	false
		run.enabled		=	false
		documentate.enabled	=	false
		test.enabled		=	false
		benchmark.enabled	=	false
	}
	private func _onBeginDebuggerCommandState(state: Set<Debugger.Command>) {
		run.enabled		=	state.contains(.Launch) ?? false
		stop.enabled		=	state.contains(.Halt) ?? false
	}
	private func _onEndDebuggerCommandState(state: Set<Debugger.Command>) {
		run.enabled		=	false
		stop.enabled		=	false
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






