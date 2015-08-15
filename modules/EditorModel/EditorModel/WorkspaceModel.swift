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

	internal init() {
		preference.owner	=	self
		search.owner		=	self
		debug.owner		=	self
		report.owner		=	self
		console.owner		=	self
		UI.owner		=	self
	}

	///

	public let	preference	=	PreferenceModel()
	public let	search		=	SearchModel()
	public let	debug		=	DebuggingModel()
	public let	report		=	ReportingModel()
	public let	console		=	Console()

	public let	UI		=	WorkspaceUIModel()

	///

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

public class WorkspaceUIModel {
	weak var owner: WorkspaceModel?

	public let	navigationPane	=	MutableValueStorage<Bool>(false)
	public let	inspectionPane	=	MutableValueStorage<Bool>(false)
	public let	consolePane	=	MutableValueStorage<Bool>(false)
}































