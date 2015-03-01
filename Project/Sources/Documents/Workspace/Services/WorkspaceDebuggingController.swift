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
import EditorUIComponents
import EditorDebuggingFeature





///	Take care that there can be multiple sessions.
///	You can check currently running sessions using `WorkspaceDebuggingController.numberOfSessions`.
protocol WorkspaceDebuggingControllerDelegate: class {
	func workspaceDebuggingControllerDidLaunchSession()
	func workspaceDebuggingControllerDidTerminateSession()
}





final class WorkspaceDebuggingController {
	weak var delegate:WorkspaceDebuggingControllerDelegate?
	weak var executionTreeViewController:ExecutionStateTreeViewController?
	weak var variableTreeViewController:VariableTreeViewController?
	
	init() {
		_dbg.async	=	true
		
		////
		
		unowned let	dbg	=	_dbg
		_menu.reconfigureReactionsForWorkspaceDebuggingController(self)
	}
	deinit {
		terminateAllSessions()
	}

	///	Provides a debug menu that controls and responds appropriately.
	///	Replace "Debug" menu for current document.
	var menuController:MenuController {
		get {
			return	_menu
		}
	}
	
	var numberOfSessions:Int {
		get {
			return	_sessions.count
		}
	}
	
	func launchSessionWithExecutableURL(u:NSURL)  {
		let	t	=	_dbg.createTargetWithFilename(u.path!)
		let	s	=	Session(owner: self, target: t)
		let	b	=	s._target.createBreakpointByName("main")
		b.enabled	=	true
		_sessions.append(s)
		
		self.delegate?.workspaceDebuggingControllerDidLaunchSession()
		_menu.reconfigureAvailabilitiesForDebugger(_dbg)
	}
	
	func terminateAllSessions() {
		for s in _sessions {
			s._dispose()
			_dbg.deleteTarget(s._target)
		}
		_sessions	=	[]
		
		self.delegate?.workspaceDebuggingControllerDidTerminateSession()
		_menu.reconfigureAvailabilitiesForDebugger(_dbg)
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
		unowned let owner:WorkspaceDebuggingController
		init(owner:WorkspaceDebuggingController, target:LLDBTarget) {
			self.owner	=	owner
			
			_target							=	target
			_listenerController				=	ListenerController()
			_listenerController.delegate	=	self
			_listenerController.startListening()
			_target.launchProcessSimplyWithWorkingDirectory(".").addListener(_listenerController.listener, eventMask: LLDBProcess.BroadcastBit.StateChanged)
		}
		
		private let _target: LLDBTarget
		private let	_listenerController: ListenerController
		
		private func _dispose() {
			_target.process.removeListener(_listenerController.listener, eventMask: LLDBProcess.BroadcastBit.StateChanged)
			_listenerController.stopListening()
			_target.process.stop()
			_target.process.kill()
		}
	}
}

extension WorkspaceDebuggingController.Session: ListenerControllerDelegate {
	func listenerControllerIsProcessingEvent(e: LLDBEvent) {
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
		
		owner._menu.reconfigureAvailabilitiesForDebugger(owner._dbg)
	}
}
























private extension DebugMenuController {
	func reconfigureAvailabilitiesForDebugger(debugger:LLDBDebugger) {
		stepOver.enabled	=	false
		stepInto.enabled	=	false
		stepOut.enabled		=	false
		
		for t in debugger.allTargets {
			switch t.process.state {
			case LLDBStateType.Attaching:	break
			case LLDBStateType.Launching:	break
			case LLDBStateType.Stepping:	break
			case LLDBStateType.Running:		break
				
			default:
				stepOver.enabled	=	true
				stepInto.enabled	=	true
				stepOut.enabled		=	true
			}
		}
	}
	func reconfigureReactionsForWorkspaceDebuggingController(owner:WorkspaceDebuggingController) {
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
		
		stepOver.reaction	=	{
			findFirstBreakpointStopThread(owner._dbg)?.stepOver()
		}
		stepInto.reaction	=	{
			findFirstBreakpointStopThread(owner._dbg)?.stepInto()
		}
		stepOut.reaction	=	{
			findFirstBreakpointStopThread(owner._dbg)?.stepOut()
		}
	}
}









