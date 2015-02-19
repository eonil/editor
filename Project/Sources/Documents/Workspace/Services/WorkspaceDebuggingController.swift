//
//  WorkspaceWorkspaceDebuggingController.swift
//  Editor
//
//  Created by Hoon H. on 2015/02/20.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import LLDBWrapper
import EditorCommon
import EditorDebuggingFeature








final class WorkspaceDebuggingController {
	weak var executionTreeViewController:ExecutionStateTreeViewController?
	weak var variableTreeViewController:VariableTreeViewController?
	
	init() {
		_dbg.async	=	true
		_menu.owner	=	self
		
		////
		
		func findFirstBreakpointStopThread(debugger:LLDBDebugger) -> LLDBThread? {
			for t1 in debugger.allTargets {
				for t2 in t1.process.allThreads {
					println(t2.stopDescription())
					switch t2.stopReason {
					case .Breakpoint:	return	t2
					case .PlanComplete:	return	t2
					default:			break
					}
				}
			}
			return	nil
		}
		unowned let	dbg	=	_dbg
		_menu.stepOver.reaction	=	{
			findFirstBreakpointStopThread(dbg)?.stepOver()
		}
		_menu.stepInto.reaction	=	{
			findFirstBreakpointStopThread(dbg)?.stepInto()
		}
		_menu.stepOut.reaction	=	{
			findFirstBreakpointStopThread(dbg)?.stepOut()
		}
	}
	deinit {
		let	ss1	=	_sessions
		for s in ss1 {
			terminateSession(s)
		}
	}

	///	Provides a debug menu that controls and responds appropriately.
	///	Replace "Debug" menu for current document.
	var menuController:MenuController {
		get {
			return	_menu
		}
	}
	func initiateSessionWithExecutableURL(u:NSURL) -> Session {
		let	t	=	_dbg.createTargetWithFilename(u.path!, andArchname: LLDBArchDefault)
		
		let	b	=	t.createBreakpointByName("main")
		b.enabled	=	true
		
		let	s	=	Session(owner: self, target: t)
		s.owner	=	self
		_sessions.append(s)
		return	s
	}
	
	///	Release session object immediately if you're retaining it.
	///	It will be invalidated after calling this.
	func terminateSession(session:Session) {
		_sessions	=	_sessions.filter { s in s !== session }
	}
	
	////
	
	private var _sessions	=	[] as [Session]
	
	private let	_dbg		=	LLDBDebugger()!
	private let	_menu		=	DebugMenuController()
}

extension WorkspaceDebuggingController {
	///	Provides a menu that can be used when no document is opened and selected.
	static var documentlessMenuController:MenuController {
		get {
			return	DebugMenuController()
		}
	}
}

extension WorkspaceDebuggingController {
	final class Session {
		unowned var owner:WorkspaceDebuggingController
		init(owner:WorkspaceDebuggingController, target:LLDBTarget) {
			self.owner	=	owner
			_target		=	target
			_listenerController				=	ListenerController()
			_listenerController.delegate	=	self
			_listenerController.startListening()
			_target.launchProcessSimplyWithWorkingDirectory(".").addListener(_listenerController.listener, eventMask: LLDBProcess.BroadcastBit.StateChanged)
		}
		deinit {
			_target.process.stop()
			_target.process.removeListener(_listenerController.listener, eventMask: LLDBProcess.BroadcastBit.StateChanged)
			_listenerController.stopListening()
		}
		
		private let _target: LLDBTarget
		private let	_listenerController: ListenerController
	}
}

extension WorkspaceDebuggingController.Session: ListenerControllerDelegate {
	func listenerController(_: ListenerController, IsProcessingEvent e: LLDBEvent) {
		let	p	=	_target.process
		
		switch p.state {
		case .Running:
			owner.executionTreeViewController?.snapshot	=	nil
			owner.variableTreeViewController?.snapshot	=	nil
			
		default:
			owner.executionTreeViewController?.snapshot	=	ExecutionStateTreeViewController.Snapshot(owner._dbg)
			if let f = p.allThreads[0].allFrames.first, f1 = f {
				owner.variableTreeViewController?.snapshot	=	VariableTreeViewController.Snapshot(f1)
			} else {
				owner.variableTreeViewController?.snapshot	=	nil
			}
		}
		
		owner._menu.refreshStates()
	}
}
























private final class DebugMenuController: MenuController {
	weak var owner:WorkspaceDebuggingController? {
		didSet {
			self.refreshStates()
		}
	}
	
	let	stepOver	=	makeMenuItem("Step Over", Command+"1")
	let	stepInto	=	makeMenuItem("Step Into", Command+"2")
	let	stepOut		=	makeMenuItem("Step Out", Command+"3")
	
	init() {
		let	m	=	NSMenu()
		m.autoenablesItems	=	false
		m.title				=	"Debug"
		m.allMenuItems		=	[
			stepOver,
			stepInto,
			stepOut,
		]
		super.init(m)
		
		refreshStates()
	}
	
	func refreshStates() {
		stepOver.enabled	=	false
		stepInto.enabled	=	false
		stepOut.enabled		=	false
		
		if let o = owner {
			for s in o._sessions {
				switch s._target.process.state {
				case LLDBStateType.Attaching:	NOOP()
				case LLDBStateType.Launching:	NOOP()
				case LLDBStateType.Stepping:	NOOP()
				case LLDBStateType.Running:		NOOP()
					
				default:
					stepOver.enabled	=	true
					stepInto.enabled	=	true
					stepOut.enabled		=	true
				}
			}
		}
	}
}




private func makeMenuItem(title:String, shortcut:MenuShortcutKeyCombination) -> NSMenuItem {
	let	m	=	NSMenuItem()
	m.title						=	title
	m.keyEquivalent				=	shortcut.plainTextKeys
	m.keyEquivalentModifierMask	=	shortcut.modifierMask
	return	m
}



private let NOOP = {} as ()->()
