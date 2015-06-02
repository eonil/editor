//
//  Reporting.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph
import EditorToolComponents

public class Console {
	
	public var issues: ArrayStorage<Issue> {
		get {
			return	_issues
		}
	}
	
	///	History of input command and result output.
	///	This is byte-stream and mostly UTF-8 encoded string
	///	but not guaranteed to be.
	///
	public var history: ArrayStorage<UInt8> {
		get {
			return	_history
		}
	}
	
	public func clearIssues() {
		_issues.removeAll()
	}
	public func clearHistory() {
		_history.removeAll()
	}
	
	///
	
	internal weak var	_ownerRepository	:	Repository?
	
	internal init() {	
	}
	
	///
	
	private let		_issues			=	EditableArrayStorage<Issue>([])
	private let		_history		=	EditableArrayStorage<UInt8>([])
}


