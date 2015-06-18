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
	
	public let	issues	=	ArrayChannel<Issue>([])
	
	///	History of input command and result output.
	///	This is a collection of lines. New-line
	///	character are stripped away.
	///
	public let	history	=	ArrayChannel<String>([])
	
	public func clearIssues() {
		issues.editor.removeAll()
	}
	public func clearHistory() {
		history.editor.removeAll()
	}
	
	///
	
	internal weak var	owner		:	Workspace?
	
	internal init() {	
	}
	
	internal func extendHistory(lines: [String]) {
		history.editor.extend(lines)
	}
}


