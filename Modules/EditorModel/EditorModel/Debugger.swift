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


///	Represents LLDB debugger.
public class Debugger {
	
	public enum Command {
		///	Adds and launches default target of owner workspace.
		case Launch
		///	Halts currently running target.
		case Halt
		case StepOver
		case StepInto
		case StepOut
	}

	public var targets: DictionaryStorage<NSURL,Target>.Channel { get { return _targets.channelize() } }
	public var availableCommands: SetStorage<Command>.Channel { get { return _availableCommands.channelize() } }
	public var currentTarget: ValueStorage<Target?>.Channel { get { return _currentTarget.channelize() } }
	
	public func execute(command: Command) {
		_executeImpl(command)
	}
	
	///	MARK:	-	
	
	internal weak var owner: Workspace? {
		willSet {
			if let _ = owner {
				_teardown()
			}
		}
		didSet {
			if let _ = owner {
				_setup()
			}
		}
	}
	
	internal init() {
		_resetAvailableCommands()
	}
	
	///	MARK:	-	
	
	private let	_lldbdebugger		=	LLDBDebugger()

	private let	_targets		=	DictionaryStorage<NSURL,Target>([:])
	private let	_availableCommands	=	SetStorage<Command>([])
	private let	_currentTarget		=	ValueStorage<Target?>(nil)
	
	private func _resetAvailableCommands() {
		_availableCommands.snapshot	=	[.Launch]
	}
	private func _executeImpl(c: Command) {
		assert(_availableCommands.snapshot.contains(c))
		assert(_currentTarget.snapshot != nil)
		if let t = currentTarget.snapshot {
			switch c {
			case .Launch:		t.launch()
			case .Halt:		t.halt()
			case .StepOver:		t.stepOver()
			case .StepInto:		t.stepInto()
			case .StepOut:		t.stepOut()
			}
		}
	}
	
	private func _setup() {
//		if let u = _defaultTargetExecutableURL() {
//			_installTargetWithURL(u)
//		}
	}
	
	private func _teardown() {
//		//	So, default-target-executable-URL shouldn't be changed
//		//	while a referencing target is alive.
//		//	If you have to change it, you must recreate the target.
//		if let u = _defaultTargetExecutableURL() {
//			_deinstallTargetWithURL(u)
//		}
	}
	
	private func _launch() {
		func installTargetIfNotInstalled() {
//			fatalError(<#message: String#>)
		}
		installTargetIfNotInstalled()
	}
	private func _halt() {
		func deinstallCurrentTarget() {
//			fatalError(<#message: String#>)
		}
		deinstallCurrentTarget()
	}
	
	private func _defaultTargetExecutableURL() -> NSURL? {
		assert(owner != nil)
		let	u	=	owner!.rootDirectoryURL.snapshot
		let	n	=	queryCargoAtDirectoryURL(u, "package.name")!
		let	u1	=	u.URLByAppendingPathComponent("target")
		let	u2	=	u1.URLByAppendingPathComponent("debug")
		let	u3	=	u2.URLByAppendingPathComponent(n)
		return	u3
	}
	
	private func _installTargetWithURL(u: NSURL) {
		assert(u.checkResourceIsReachableAndReturnError(nil) == true, "Target executable file must exists to be added as a target.")
		let	t1	=	_lldbdebugger.createTargetWithFilename(u.path!)!
		let	wdir	=	u.URLByDeletingLastPathComponent!
		let	t	=	Target(workingDirectoryURL: wdir, LLDBTarget: t1)
		_targets[u]	=	t
		t.owner		=	self
	}
	
	private func _deinstallTargetWithURL(u: NSURL) {
		assert(_targets[u] != nil)
		if let t = _targets[u] {
			t.halt()
			_targets.removeValueForKey(u)
			t.owner	=	nil
		}
	}
}




















public class Target {
	
	public var debugger: Debugger {
		get {
			return	owner!
		}
	}

	public var	availableCommands	:	SetStorage<Debugger.Command>.Channel	{ get { return _availableCommands.channelize() } }
	public var	isRunning		:	ValueStorage<Bool>.Channel 		{ get { return _isRunning.channelize() } }
	public var	stackFrames		:	ValueStorage<ExecutionStateTreeViewController.Snapshot?>.Channel { get { return _stackFrames.channelize() } }
	public var	localVariables		:	ValueStorage<VariableTreeViewController.Snapshot?>.Channel { get { return _localVariables.channelize() } }

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
		
		resetAvailableCommands()
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

	private let	_availableCommands	=	SetStorage<Debugger.Command>([])
	private let	_isRunning		=	ValueStorage<Bool>(false)

	private let	_stackFrames		=	ValueStorage<ExecutionStateTreeViewController.Snapshot?>(nil)
	private let	_localVariables		=	ValueStorage<VariableTreeViewController.Snapshot?>(nil)

	private let	_workingDir	:	NSURL
	private let	_lldbtarget	:	LLDBTarget
	private let	_listenControl	:	ListenerController
	private let	_listenAgent	:	ListenerAgent
	private var	_lldbprocess	:	LLDBProcess?

	
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
	
	private func resetAvailableCommands() {
		_availableCommands.snapshot	=	resolveAvailableCommandsForProcessState(_lldbprocess!)
	}
	
	private func onEvent(e: LLDBEvent) {
		switch _lldbprocess!.state {
		case .Running:
			_stackFrames.snapshot		=	nil
			_localVariables.snapshot	=	nil
			
		default:
			_stackFrames.snapshot	=	ExecutionStateTreeViewController.Snapshot(debugger._lldbdebugger)
			
			if let f = _lldbprocess!.allThreads[0].allFrames.first, f1 = f {
				_localVariables.snapshot	=	VariableTreeViewController.Snapshot(f1)
			} else {
				_localVariables.snapshot	=	nil
			}
		}
		
		resetAvailableCommands()
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
	default:			return	[.Launch, .Halt, .StepOver, .StepInto, .StepOut]
	}
}







