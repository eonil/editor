//
//  Racer.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import SignalGraph
import EditorToolComponents

public class Racer {
	
	public typealias	Match		=	EditorToolComponents.RacerExecutionController.Match
	
	public var tools: Toolbox {
		get {
			return	owner!
		}
	}
	public var autocompletionCandidates: ArrayStorage<EditorToolComponents.Model.Autocompletion.Candidate>.Channel {
		get {
			return	toolModel.autocompletion.candidates
		}
	}
	public func requeryAutocompletion(file: String, line: Int, column: Int) {
		toolModel.autocompletion.query((file, line, column))
	}
	
	///	MARK:	-
	
	internal weak var owner	:	Toolbox?
	internal init() {
	}
	
	///
	
	private let		toolModel	=	EditorToolComponents.Model()
	
	private func _haltQuerying() {
		
	}
	private func _runQueying(file: String, line: Int, column: Int) {
	}
}





