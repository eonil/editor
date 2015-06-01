//
//  Repository.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/05/24.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph
import EditorToolComponents



public class Repository {
	public let		editing		=	Editing()
	public let		issues		=	EditableArrayStorage<Issue>([])
	public let		tools		=	Tools()
}



public class Editing {
	public let		currentFileURL	=	EditableValueStorage<NSURL?>(nil)
}



public class Tools {
	public typealias	Match		=	EditorToolComponents.RacerExecutionController.Match
	
	public var autocompletionCandidates: ArrayStorage<Match> {
		get {
			return	toolModel.autocompletion.candidates
		}
	}
	public var cargoIsRunning: ValueStorage<Bool> {
		get {
			return	_cargoIsRunning;
		}
	}
	
	public func queryAutocompletion(file: String, line: Int, column: Int) {
		toolModel.autocompletion.query((file, line, column))
	}
	
//	public func cancelAllCargoOperations() {
//		_cargoExecution!.
//	}
	public func runCargoBuild(workingDirectoryURL: NSURL) {
		assert(_cargoExecution == nil);
		_cargoExecution	=	CargoExecutionController()
		_cargoExecution!.launchBuild(workingDirectoryURL: workingDirectoryURL)
	}
	public func runCargoClean(workingDirectoryURL: NSURL) {
		assert(_cargoExecution == nil);
		_cargoExecution	=	CargoExecutionController()
		_cargoExecution!.launchClean(workingDirectoryURL: workingDirectoryURL)
	}
	public func executeCargoTarget(workingDirectoryURL: NSURL) {
		assert(_cargoExecution == nil);
		_cargoExecution!.launchRun(workingDirectoryURL: workingDirectoryURL)
	}
	
	///	MARK:	-	
	
	private let		toolModel	=	EditorToolComponents.Model()

	private var		_cargoExecution	:	CargoExecutionController?
	private let		_cargoIsRunning	=	EditableValueStorage<Bool>(false);
}


















