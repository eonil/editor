//
//  WorkspaceModel.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

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

	///

	private let	_projects	=	MutableArrayStorage<ProjectModel>([])
	private let	_currentProject	=	MutableValueStorage<ProjectModel?>(nil)
}


///	A unit of build.
public class ProjectModel {
	public var	rootURL	:	NSURL?

	public let	report	=	Report()
	public let	console	=	Console()
}

public class SearchModel {

}

///	A unit of build for specific environment.
public class TargetModel {

}

public class DebuggingModel {

	var stackFrames: ArrayStorage<StackFrame> {
		get {
			return	_stackFrames
		}
	}
	var frameVariables: ArrayStorage<FrameVariable> {
		get {
			return	_frameVariables
		}
	}

	func launchCurrentTarget() {

	}
	func pause() {

	}
	func resume() {

	}
	func halt() {

	}

	func selectFrameAtIndex(index: Int) {

	}
	func deselectFrame() {

	}
	func reloadFrameAtIndex(index: Int) {

	}

	///

	private let	_stackFrames	=	MutableArrayStorage<StackFrame>([])
	private let	_frameVariables	=	MutableArrayStorage<FrameVariable>([])

	///

	public class StackFrame {

	}
	public class FrameVariable {

	}
}

public class Console {
	public var outputLines: ArrayStorage<String> {
		get {
			return	_outputLines
		}
	}
	public func appendLine(line: String) {

	}
	public func appendLines(lines: String) {

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
























