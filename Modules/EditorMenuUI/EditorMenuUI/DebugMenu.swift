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
	
	private func _connect() {
		workspace!.debugger.availableCommands.register(ObjectIdentifier(self)) { [weak self] in self!._handleAvailableDebuggerCommandSignal($0) }
	}
	private func _disconnect() {
		workspace!.debugger.availableCommands.deregister(ObjectIdentifier(self))
	}
	private func _handleAvailableDebuggerCommandSignal(s: SetStorage<Debugger.Command>.Signal) {
		stepOver.enabled	=	s.timing == .DidBegin && s.state.contains(.StepOver) ?? false
		stepInto.enabled	=	s.timing == .DidBegin && s.state.contains(.StepInto) ?? false
		stepOut.enabled		=	s.timing == .DidBegin && s.state.contains(.StepOut) ?? false
	}
}








