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
	public let		ediing		=	Editing()
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
	
	public func queryAutocompletion(file: String, line: Int, column: Int) {
		toolModel.autocompletion.query((file, line, column))
	}
	
	///	MARK:	-	
	
	internal let		toolModel	=	EditorToolComponents.Model()
}

