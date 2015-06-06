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
	
	public weak var workspace: Workspace? {
		willSet {
			if let _ = workspace {
				teardown()
			}
		}
		didSet {
			if let _ = workspace {
				setup()
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
	
	private let	_cargoAvailableCommands			=	ReplicatingValueStorage<Set<Cargo.Command>>()
	private let	_debuggerAvailableCommands		=	ReplicatingValueStorage<Set<Debugger.Command>>()
	
	private let	_cargoAvailableCommandsMonitor		=	SignalMonitor<ValueSignal<Set<Cargo.Command>>>()
	private let	_debuggerAvailableCommandsMonitor	=	SignalMonitor<ValueSignal<Set<Debugger.Command>>>()
	
	private func setup() {
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
		
		_cargoAvailableCommandsMonitor.handler		=	{ [weak self] s in self?.reconfigureForCargoCommands(s) }
		_debuggerAvailableCommandsMonitor.handler	=	{ [weak self] s in self?.reconfigureForDebuggerCommands(s) }
		_cargoAvailableCommands.emitter.register(_cargoAvailableCommandsMonitor)
		_debuggerAvailableCommands.emitter.register(_debuggerAvailableCommandsMonitor)
		workspace!.toolbox.cargo.availableCommands.emitter.register(_cargoAvailableCommands.sensor)
		workspace!.debugger.availableCommands.emitter.register(_debuggerAvailableCommands.sensor)
	}
	private func teardown() {
		workspace!.debugger.availableCommands.emitter.deregister(_debuggerAvailableCommands.sensor)
		workspace!.toolbox.cargo.availableCommands.emitter.deregister(_cargoAvailableCommands.sensor)
		_debuggerAvailableCommands.emitter.deregister(_debuggerAvailableCommandsMonitor)
		_cargoAvailableCommands.emitter.deregister(_cargoAvailableCommandsMonitor)
		_debuggerAvailableCommandsMonitor.handler	=	{ _ in }
		_cargoAvailableCommandsMonitor.handler		=	{ _ in }
		
		for m in menu.allMenuItems {
			m.onAction	=	nil
		}
	}
	private func reconfigureForCargoCommands(s: ValueSignal<Set<Cargo.Command>>) {
		clean.enabled		=	s.state?.contains(.Clean) ?? false
		build.enabled		=	s.state?.contains(.Build) ?? false
		run.enabled		=	s.state?.contains(.Run) ?? false
		documentate.enabled	=	s.state?.contains(.Documentate) ?? false
		test.enabled		=	s.state?.contains(.Test) ?? false
		benchmark.enabled	=	s.state?.contains(.Benchmark) ?? false
	}
	private func reconfigureForDebuggerCommands(s: ValueSignal<Set<Debugger.Command>>) {
		run.enabled		=	s.state?.contains(.Launch) ?? false
		stop.enabled		=	s.state?.contains(.Halt) ?? false
	}
}
