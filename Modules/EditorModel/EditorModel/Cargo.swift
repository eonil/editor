//
//  Cargo.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import SignalGraph
import EditorToolComponents

public class Cargo {
	///	Please note that `cargo` run just runs produced executable with no debugger.
	public enum Command {
		case Clean
		case Build
		case Run
		case Documentate
		case Test
		case Benchmark
	}
	
	///
	
	public var tools: Toolbox {
		get {
			return	owner!
		}
	}
	
	public let	availableCommands	=	ValueChannel<Set<Command>>([])
	public let	runningCommand		=	ValueChannel<Command?>(nil)
	public let	waitingCommands		=	ArrayChannel<Command>([])

	public func queue(command: Command) {
		waitingCommands.editor.append(command)
	}
	public func cancelAll() {
		waitingCommands.editor.removeAll()
	}
	
	///
	
	internal weak var owner	:	Toolbox?
	internal init() {
		_cargoAgent.owner	=	self;
		resetAvailableCommands()
	}
	
	///
	
	private var	_cargoExecution		:	CargoExecutionController?
	private let	_cargoAgent		=	CargoAgent()
	
	private func _execute(cmd: Command) {
		assert(_cargoExecution == nil)
		
		let	exe	=	CargoExecutionController()
		let	u	=	tools.workspace.rootDirectoryURL.storage.state
		exe.delegate	=	_cargoAgent
		
		runningCommand.editor.state	=	cmd
		
		switch cmd {
		case .Clean:
			exe.launchClean(workingDirectoryURL: u)
			
		case .Build:
			exe.launchBuild(workingDirectoryURL: u)
			
		case .Run:
			exe.launchRun(workingDirectoryURL: u)
			
		case .Documentate:
			assert(false, "Unimplemented yet.")
			break
			
		case .Test:
			assert(false, "Unimplemented yet.")
			break
			
		case .Benchmark:
			assert(false, "Unimplemented yet.")
			break
		}
	}
	
	private func resetAvailableCommands() {
		availableCommands.editor.state			=	[.Clean, .Build]
	}
	
	private class CargoAgent: CargoExecutionControllerDelegate {
		weak var owner	:	Cargo?
		func cargoExecutionControllerDidPrintMessage(s:String) {
			let	lines	=	split(s, maxSplit: Int.max, allowEmptySlices: true, isSeparator: { $0 == "\n" })
			owner!.tools.workspace.console.extendHistory(lines)
		}
		func cargoExecutionControllerDidDiscoverRustCompilationIssue(issue:RustCompilerIssue) {
			owner!.tools.workspace.console.extendHistory([issue.description])
		}
		func cargoExecutionControllerRemoteProcessDidTerminate() {
			owner!.tools.workspace.console.extendHistory([""])
			owner!.runningCommand.editor.state	=	nil
			owner!.resetAvailableCommands()
		}
	}
}

