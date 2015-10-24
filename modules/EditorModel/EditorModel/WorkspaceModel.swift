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





/// A unit for a product.
/// A workspace can contain multiple projects.
///
/// You need to call `locate` to designate location of this
/// workspace. Workspace will be in an empty state until you
/// provide a location.
///
/// A workspace should work with an invalid path without crash.
/// A workspace can work even with `nil` locaiton. Anyway most
/// feature won't work with invalid paths.
///
public class WorkspaceModel: ModelSubnode<ApplicationModel> {

	override func didJoinModelRoot() {
		super.didJoinModelRoot()

		file.owner		=	self
		search.owner		=	self
		build.owner		=	self
		debug.owner		=	self
		report.owner		=	self
		console.owner		=	self
		cargo.owner		=	self
		UI.owner		=	self
	}
	override func willLeaveModelRoot() {
		super.willLeaveModelRoot()

		UI.owner		=	nil
		cargo.owner		=	nil
		console.owner		=	nil
		report.owner		=	nil
		debug.owner		=	nil
		build.owner		=	nil
		search.owner		=	nil
		file.owner		=	nil
	}

	///

	public var application: ApplicationModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	public let	file		=	FileTreeModel()
	public let	search		=	SearchModel()
	public let	build		=	BuildModel()
	public let	debug		=	DebuggingModel()
	public let	report		=	ReportingModel()
	public let	console		=	ConsoleModel()

	public let	UI		=	WorkspaceUIModel()

	internal let	cargo		=	CargoModel()

	///

	/// A location for a project can be changed to provide smoother
	/// user experience.
	/// For instance, user can move workspace directory to another
	/// location, and we can just replace location without re-creating
	/// whole workspace UI.
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

	///

	/// Specifies location of this workspace.
	public func locate(u: NSURL) {
		assert(_location.value == nil)
		_location.value	=	u
		file.restoreSnapshot()
	}
	public func delocate() {
		assert(_location.value != nil)
		file.storeSnapshot()
		_location.value	=	nil
	}

	/// Creates a new workspace file structure at current location
	/// if there's none. This method does not guarantee proper creation,
	/// and can fail for any reason.
	public func tryCreating() {
		assert(_location.value != nil)
		let	u	=	_location.value!
		cargo.runNewAtURL(u)
	}

	public func insertProjectWithRootURL(url: NSURL) {
		assert(_location.value != nil, "You cannot manage projects on a workspace with no location.")
		let	p	=	ProjectModel()
		p.owner		=	self
		_projects
	}
	public func deleteProject(project: ProjectModel) {
		assert(_location.value != nil, "You cannot manage projects on a workspace with no location.")
		markUnimplemented()
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































