//
//  WorkspaceModel.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

///	A unit for a product.
///	A workspace can contain multiple projects.
public class WorkspaceModel {
	public var allProjects: ArrayStorage<ProjectModel> {
		get {
			return	_projects
		}
	}
	public var curerntProject: ValueStorage<ProjectModel?> {
		get {
			return	_currentProject
		}
	}

	public func insertProjectWithRootURL(url: NSURL) {
		let	p	=	ProjectModel()
		p.owner		=	self
		_projects
	}
	public func deleteProject(project: ProjectModel) {

	}

	///

	private let	_projects	=	MutableArrayStorage<ProjectModel>([])
	private let	_currentProject	=	MutableValueStorage<ProjectModel?>(nil)
}


///	A unit of build for specific environment.
public class TargetModel {

}

public class Console {
	public var outputLines: ArrayStorage<String> {
		get {
			return	_outputLines
		}
	}
	public func appendLine(line: String) {
		fatalErrorBecauseUnimplementedYet()
	}
	public func appendLines(lines: String) {
		fatalErrorBecauseUnimplementedYet()
	}

	///

	private let	_outputLines	=	MutableArrayStorage<String>([])
}









public class Report {
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
























