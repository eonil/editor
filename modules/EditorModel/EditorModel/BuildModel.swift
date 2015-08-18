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
	}

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_runnableCommands.value	=	[.Build, .Clean]
		workspace.cargo.state.registerDidSet(ObjectIdentifier(self)) { [weak self] in self?._applyCargoState() }
	}
	override func willLeaveModelRoot() {
		workspace.cargo.state.deregisterDidSet(ObjectIdentifier(self))
		_runnableCommands.value	=	[]
		super.willLeaveModelRoot()
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
//		assert(workspace.currentProject.value != nil)
//		assert(workspace.currentProject.value!.rootURL.value != nil)

		assert(workspace.location.value != nil)
		if let u =  workspace.location.value {
			workspace.cargo.runBuildAtURL(u)
			assert(workspace.cargo.state.value == .Running)
		}
	}
	public func runClean() {
		assert(isRooted)
		_runnableCommands.value	=	[.Stop]
		markUnimplemented()
	}
	public func stop() {
		assert(isRooted)
		markUnimplemented()
	}

	///

	private let	_runnableCommands	=	MutableValueStorage<Set<BuildCommand>>([])

	private func _applyCargoState() {
		if let state = workspace.cargo.state.value {
			switch state {
			case .Ready:
				_runnableCommands.value	=	[]
			case .Running:
				_runnableCommands.value	=	[.Stop]
			case .Done:
				//	Can do nothing at this state.
				//	Wait for resetting...
				_runnableCommands.value	=	[]
				break

			case .Error:
				//	Can do nothing at this state.
				//	Wait for resetting...
				_runnableCommands.value	=	[]
				break
			}
		}
		else {
			_runnableCommands.value	=	[.Build, .Clean]
		}
	}
}





