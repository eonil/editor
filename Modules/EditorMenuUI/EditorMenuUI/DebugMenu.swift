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
				_teardown()
			}
		}
		didSet {
			if let _ = workspace {
				_setup()
			}
		}
	}
	
	///	
	
	let	stepOver	=	NSMenuItem(title: "Step Over", shortcut: Command+"1")
	let	stepInto	=	NSMenuItem(title: "Step Into", shortcut: Command+"2")
	let	stepOut		=	NSMenuItem(title: "Step Out", shortcut: Command+"3")

	///

	private var	_channelings	:	AnyObject?
	
	private func _setup() {
		_channelings	=	Channeling(workspace!.debugger.availableCommands,	{ [weak self] s in self?._reconfigureForDebuggerCommands(s) })
	}
	private func _teardown() {
		_channelings	=	nil
	}
	private func _reconfigureForDebuggerCommands(s: ValueSignal<Set<Debugger.Command>>) {
		stepOver.enabled	=	s.state?.contains(.StepOver) ?? false
		stepInto.enabled	=	s.state?.contains(.StepInto) ?? false
		stepOut.enabled		=	s.state?.contains(.StepOut) ?? false
	}
}








