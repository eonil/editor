//
//  BuildModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

public enum BuildCommand {
	case Build
	case Clean
	case Stop
}

public class BuildModel: ModelSubnode<WorkspaceModel> {

	public var workspace: WorkspaceModel {
		get {
			return	owner!
		}
	}

	///

	deinit {
		assert(_runningCargo == nil)
	}

	override func didJoinModelRoot() {
		_runnableCommands.value	=	[.Build, .Clean]
		super.didJoinModelRoot()
	}
	override func willLeaveModelRoot() {
		super.willLeaveModelRoot()
		_runnableCommands.value	=	[]
	}

	///

	public var runnableCommands: ValueStorage<Set<BuildCommand>> {
		get {
			assert(isRooted || _runnableCommands.value == [])
			return	_runnableCommands
		}
	}

	///

	public func runBuild() {
		assert(isRooted)
		assert(workspace.currentProject.value != nil)
		assert(workspace.currentProject.value!.rootURL.value != nil)
		assert(_runningCargo == nil)
		_runnableCommands.value	=	[.Stop]
		_runningCargo	=	CargoTool(rootDirectoryURL: workspace.currentProject.value!.rootURL.value!)
		_runningCargo!.runBuild()
	}
	public func runClean() {
		assert(isRooted)
		assert(_runningCargo == nil)
		_runnableCommands.value	=	[.Stop]
		_runningCargo	=	CargoTool(rootDirectoryURL: workspace.currentProject.value!.rootURL.value!)
		_runningCargo!.runClean()
	}
	public func stop() {
		assert(isRooted)
		assert(_runningCargo != nil)
		_runningCargo!.stop()
		_runningCargo	=	nil
		_runnableCommands.value	=	[.Build, .Clean]
	}

	///

	private var	_runningCargo		:	CargoTool?
	private let	_runnableCommands	=	MutableValueStorage<Set<BuildCommand>>([])
}





