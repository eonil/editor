
//
//  Tools.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph
import EditorToolComponents


public class Tools {
	public let	racer	=	Racer()
	public let	cargo	=	Cargo()

	public var workspace: Workspace {
		get {
			return	owner!
		}
	}
	
	///
	
	internal weak var owner	:	Workspace?
	internal init() {
		racer.owner	=	self
		cargo.owner	=	self
	}
}

public class Racer {
	
	public typealias	Match		=	EditorToolComponents.RacerExecutionController.Match
	
	public var tools: Tools {
		get {
			return	owner!
		}
	}
	public var autocompletionCandidates: ArrayStorage<Match> {
		get {
			return	toolModel.autocompletion.candidates
		}
	}
	public func requeryAutocompletion(file: String, line: Int, column: Int) {
		toolModel.autocompletion.query((file, line, column))
	}
	
	///	MARK:	-
	
	internal weak var owner	:	Tools?
	internal init() {
	}
	
	///
	
	private let		toolModel	=	EditorToolComponents.Model()
	
	private func _haltQuerying() {
		
	}
	private func _runQueying(file: String, line: Int, column: Int) {
	}
}

public class Cargo {
	public enum Command {
		case Clean
		case Build
		case Launch
	}
	
	public var tools: Tools {
		get {
			return	owner!
		}
	}
	public var running: ValueStorage<Command?> {
		get {
			return	_running
		}
	}
	public var waitings: ArrayStorage<Command> {
		get {
			return	_waitings
		}
	}
	public func queue(command: Command) {
		_waitings.append(command)
	}
	public func cancelAll() {
		_waitings.removeAll()
	}
	
	///
	
	internal weak var owner	:	Tools?
	internal init() {
		_cargoAgent.owner	=	self;
	}
	
	///
	
	private let	_running	=	EditableValueStorage<Command?>(nil)
	private let	_waitings	=	EditableArrayStorage<Command>([])
	
	private var	_cargoExecution	:	CargoExecutionController?
	private let	_cargoAgent	=	CargoAgent()
	
	private func _execute(cmd: Command) {
		assert(_cargoExecution == nil)
		
		let	exe	=	CargoExecutionController()
		let	u	=	tools.workspace.rootDirectoryURL.state
		exe.delegate	=	_cargoAgent
		
		switch cmd {
		case .Clean:
			exe.launchClean(workingDirectoryURL: u)
			
		case .Build:
			exe.launchBuild(workingDirectoryURL: u)
			
		case .Launch:
			exe.launchRun(workingDirectoryURL: u)
			
		}
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
		}
	}
}

