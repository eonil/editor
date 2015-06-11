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

public class DebugMenuController {
	
	public let	menu	=	NSMenu()
	
	public init() {
		menu.autoenablesItems	=	false
		menu.title		=	"Debug"
		menu.allMenuItems	=	[
			stepOver,
			stepInto,
			stepOut,
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
	
	let	stepOver	=	NSMenuItem(title: "Step Over", shortcut: Command+"1")
	let	stepInto	=	NSMenuItem(title: "Step Into", shortcut: Command+"2")
	let	stepOut		=	NSMenuItem(title: "Step Out", shortcut: Command+"3")

	///

	private let	_debuggerAvailableCommands		=	ReplicatingValueStorage<Set<Debugger.Command>>()
	
	private let	_debuggerAvailableCommandsMonitor	=	SignalMonitor<ValueSignal<Set<Debugger.Command>>>()
	
	private func setup() {
		_debuggerAvailableCommandsMonitor.handler	=	{ [weak self] s in self?.reconfigureForDebuggerCommands(s) }
		_debuggerAvailableCommands.emitter.register(_debuggerAvailableCommandsMonitor)
		workspace!.debugger.availableCommands.storage.emitter.register(_debuggerAvailableCommands.sensor)
	}
	private func teardown() {
		workspace!.debugger.availableCommands.storage.emitter.deregister(_debuggerAvailableCommands.sensor)
		_debuggerAvailableCommands.emitter.deregister(_debuggerAvailableCommandsMonitor)
		_debuggerAvailableCommandsMonitor.handler	=	{ _ in }
	}
	private func reconfigureForDebuggerCommands(s: ValueSignal<Set<Debugger.Command>>) {
		stepOver.enabled	=	s.state?.contains(.StepOver) ?? false
		stepInto.enabled	=	s.state?.contains(.StepInto) ?? false
		stepOut.enabled		=	s.state?.contains(.StepOut) ?? false
	}
}








