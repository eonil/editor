//
//  Console.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph
import EditorToolComponents

public class Console {
	
	public var workspace: Workspace {
		get {
			return	owner!
		}
	}

	public var issues: ArrayStorage<Issue>.Channel { get { return _issues.channelize() } }

	///	History of input command and result output.
	///	This is a collection of lines. New-line
	///	character are stripped away.
	///
	public var history: ArrayStorage<String>.Channel { get { return _history.channelize() } }

	public func clearIssues() {
		_issues.removeAll()
	}
	public func clearHistory() {
		_history.removeAll()
	}
	
	///

	internal let		_issues		=	ArrayStorage<Issue>([])
	internal let		_history	=	ArrayStorage<String>([])
	internal weak var	owner		:	Workspace?
	
	internal init() {
	}
	
	internal func extendHistory(lines: [String]) {
		_history.extend(lines)
	}
}


