//
//  Debugger.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph
import LLDBWrapper
import EditorDebuggingFeature


public class Debugger {
	
	public enum Command {
//		case Launch
//		case Halt
		case StepOver
		case StepInto
		case StepOut
	}
	
	public var targets: ArrayStorage<Target> {
		get {
			return	_targets
		}
	}
	
	public var availableCommands: ValueStorage<Set<Command>> {
		get {
			return	_availableCommands
		}
	}
	
	public func addTargetWithURL(u: NSURL) {
		let	t1	=	_lldbdebugger.createTargetWithFilename(u.path!)!
		let	wdir	=	u.URLByDeletingLastPathComponent!
		let	t	=	Target(workingDirectoryURL: wdir, LLDBTarget: t1)
		_targets.append(t)
	}
//	public func removeTargetWithURL(u: NSURL) {
//		
//	}
	
	///	MARK:	-	
	
	internal weak var	owner		:	Workspace?
	
	internal init() {
		
	}
	
	///	MARK:	-	
	
	private let	_lldbdebugger		=	LLDBDebugger()
	private let	_targets		=	EditableArrayStorage<Target>([])
	private let	_availableCommands	=	EditableValueStorage<Set<Command>>(Set())
	
	private func execute(c: Command) {
		assert(_availableCommands.state.contains(c))
		
		
	}
	
}

public class Target {
	
	public var debugger: Debugger {
		get {
			return	owner!
		}
	}
	
	public var isRunning: ValueStorage<Bool> {
		get {
			return	_isRunning
		}
	}
	public func launch() {
		_lldbprocess	=	_lldbtarget.launchProcessSimplyWithWorkingDirectory(_workingDir.path!)
		let	b	=	_lldbtarget.createBreakpointByName("main")
		b.enabled	=	true
	}
	
	public func halt() {
		_lldbprocess!.stop()
	}
	
	public func stepOver() {
		findFirstBreakpointStopThread()!.stepOver()
	}
	
	public func stepInto() {
		findFirstBreakpointStopThread()!.stepInto()
	}
	
	public func stepOut() {
		findFirstBreakpointStopThread()!.stepOut()
	}

	////
	
	internal weak var	owner		:	Debugger?
	
	internal init(workingDirectoryURL: NSURL, LLDBTarget lldbtarget: LLDBTarget) {
		_workingDir			=	workingDirectoryURL
		_lldbtarget			=	lldbtarget
		_listenControl			=	ListenerController()
		_listenAgent			=	ListenerAgent()
		_listenAgent.owner		=	self
		_listenControl.delegate		=	_listenAgent
		_listenControl.startListening()
		
		_lldbprocess			=	_lldbtarget.launchProcessSimplyWithWorkingDirectory(_workingDir.path!)
		_lldbprocess!.addListener(_listenControl.listener, eventMask: LLDBProcess.BroadcastBit.StateChanged)
	}
	deinit {
		_lldbprocess!.removeListener(_listenControl.listener, eventMask: LLDBProcess.BroadcastBit.StateChanged)
		
		_lldbprocess!.stop()
		_lldbprocess!.kill()
		
		_listenControl.stopListening()
		_listenControl.delegate		=	nil
		_listenAgent.owner		=	nil
	}
	
	///	MARK:	-
	
	private let		_workingDir	:	NSURL
	private let		_lldbtarget	:	LLDBTarget
	private let		_listenControl	:	ListenerController
	private let		_listenAgent	:	ListenerAgent
	private var		_lldbprocess	:	LLDBProcess?
	
	private let		_isRunning	=	EditableValueStorage<Bool>(false)
	private let		_stackFrames	=	EditableValueStorage<ExecutionStateTreeViewController.Snapshot?>(nil)
	private let		_localVariables	=	EditableValueStorage<VariableTreeViewController.Snapshot?>(nil)
	
	private func findFirstBreakpointStopThread() -> LLDBThread? {
		assert(_lldbprocess != nil)
		for t2 in _lldbprocess!.allThreads {
			println(t2.stopDescription())
			switch t2.stopReason {
			case .Breakpoint:	return	t2
			case .PlanComplete:	return	t2
			default:			break
			}
		}
		return	nil
	}
	
	private func onEvent(e: LLDBEvent) {
		switch _lldbprocess!.state {
		case .Running:
			_stackFrames.state	=	nil
			_localVariables.state	=	nil
			
		default:
			_stackFrames.state	=	ExecutionStateTreeViewController.Snapshot(debugger._lldbdebugger)
			
			if let f = _lldbprocess!.allThreads[0].allFrames.first, f1 = f {
				_localVariables.state	=	VariableTreeViewController.Snapshot(f1)
			} else {
				_localVariables.state	=	nil
			}
		}
		
		debugger._availableCommands.state	=	resolveAvailableCommandsForProcessState(_lldbprocess!)
	}
}













private class ListenerAgent: ListenerControllerDelegate {
	weak var	owner		:	Target?

	func listenerControllerIsProcessingEvent(e:LLDBEvent) {
		owner!.onEvent(e)
	}
}


private func resolveAvailableCommandsForProcessState(p: LLDBProcess) -> Set<Debugger.Command> {
	switch p.state {
	case LLDBStateType.Attaching:	return	[]
	case LLDBStateType.Launching:	return	[]
	case LLDBStateType.Stepping:	return	[]
	case LLDBStateType.Running:	return	[]
	default:			return	[.StepOver, .StepInto, .StepOut]
	}
}







