//
//  ReportingModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon



public class ReportingModel: ModelSubnode<WorkspaceModel> {

	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	///
	
	public var errors: ArrayStorage<Issue> {
		get {
			return	_errors
		}
	}
	public var warnings: ArrayStorage<Issue> {
		get {
			return	_errors
		}
	}
	public var informations: ArrayStorage<Issue> {
		get {
			return	_errors
		}
	}

	private let	_errors		=	MutableArrayStorage<Issue>([])
	private let	_warnings	=	MutableArrayStorage<Issue>([])
	private let	_informations	=	MutableArrayStorage<Issue>([])
}


public struct Issue {
	public var	severity	:	Severity
	public var	toolID		:	ToolID
	public var	fileURL		:	NSURL
	public var	message		:	String

	public enum Severity {
		case Information
		case Warning
		case Error
	}
}

public enum ToolID {
	case Cargo
	case Racer
}

