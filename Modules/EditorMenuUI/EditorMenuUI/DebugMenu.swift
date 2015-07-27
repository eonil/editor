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
				_disconnect()
			}
		}
		didSet {
			if let _ = workspace {
				_connect()
			}
		}
	}
	
	///	
	
	let	stepOver	=	NSMenuItem(title: "Step Over", shortcut: Command+"1")
	let	stepInto	=	NSMenuItem(title: "Step Into", shortcut: Command+"2")
	let	stepOut		=	NSMenuItem(title: "Step Out", shortcut: Command+"3")

	///

	private let	_availableDebuggerCommandMonitor	=	SetMonitor<Debugger.Command>()

	private func _connect() {
		_availableDebuggerCommandMonitor.didBegin	=	{ [weak self] in self!._beginDebuggerCommandState($0) }
		_availableDebuggerCommandMonitor.willEnd	=	{ [weak self] in self!._endDebuggerCommandState($0) }
		workspace!.debugger.availableCommands.register(_availableDebuggerCommandMonitor)
	}
	private func _disconnect() {
		workspace!.debugger.availableCommands.deregister(_availableDebuggerCommandMonitor)
		_availableDebuggerCommandMonitor.didBegin	=	nil
		_availableDebuggerCommandMonitor.willEnd	=	nil
	}
	private func _beginDebuggerCommandState(dcmds: Set<Debugger.Command>) {
		stepOver.enabled	=	dcmds.contains(.StepOver) ?? false
		stepInto.enabled	=	dcmds.contains(.StepInto) ?? false
		stepOut.enabled		=	dcmds.contains(.StepOut) ?? false
	}
	private func _endDebuggerCommandState(dcmds: Set<Debugger.Command>) {
		stepOver.enabled	=	false
		stepInto.enabled	=	false
		stepOut.enabled		=	false
	}
}








