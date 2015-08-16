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
public class WorkspaceModel: ModelSubnode<ApplicationModel> {

	internal init(rootLocationURL: NSURL) {
		super.init()
		_location.value		=	rootLocationURL
	}

	///

	override func didJoinModelRoot() {
		super.didJoinModelRoot()

		search.owner		=	self
		build.owner		=	self
		debug.owner		=	self
		report.owner		=	self
		console.owner		=	self
		UI.owner		=	self
	}
	override func willLeaveModelRoot() {
		super.willLeaveModelRoot()

		UI.owner		=	nil
		console.owner		=	nil
		report.owner		=	nil
		debug.owner		=	nil
		build.owner		=	nil
		search.owner		=	nil
	}

	///

	public var application: ApplicationModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	public let	search		=	SearchModel()
	public let	build		=	BuildModel()
	public let	debug		=	DebuggingModel()
	public let	report		=	ReportingModel()
	public let	console		=	ConsoleModel()

	public let	UI		=	WorkspaceUIModel()

	///

	public var location: ValueStorage<NSURL?> {
		get {
			return	_location
		}
	}
	public var allProjects: ArrayStorage<ProjectModel> {
		get {
			return	_projects
		}
	}
	public var currentProject: ValueStorage<ProjectModel?> {
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

	private let	_location	=	MutableValueStorage<NSURL?>(nil)
	private let	_projects	=	MutableArrayStorage<ProjectModel>([])
	private let	_currentProject	=	MutableValueStorage<ProjectModel?>(nil)
}





public class WorkspaceUIModel: ModelSubnode<WorkspaceModel> {

	public let	navigationPane	=	MutableValueStorage<Bool>(false)
	public let	inspectionPane	=	MutableValueStorage<Bool>(false)
	public let	consolePane	=	MutableValueStorage<Bool>(false)

}































