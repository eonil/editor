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

	override init() {
		super.init()
		_event.sender	=	self
	}
	deinit {
	}

	///

	public var event: MulticastChannel<Event> {
		get {
			return	_event
		}
	}
	private let	_event	=	MulticastStationWithGlobalNotification<Event>()

	///

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		runnableCommands2	=	[.Build, .Clean]
		workspace.cargo.state.registerDidSet(ObjectIdentifier(self)) { [weak self] in self?._applyCargoState() }
	}
	override func willLeaveModelRoot() {
		workspace.cargo.state.deregisterDidSet(ObjectIdentifier(self))
		runnableCommands2	=	[]
		super.willLeaveModelRoot()
	}

	///

	public private(set) var runnableCommands2: Set<BuildCommand> = [] {
		willSet {
			assert(isRooted || runnableCommands2 == [])
			Event.WillChangeRunnableCommand.broadcastWithSender(self)
		}
		didSet {
			_runnableCommands.value	=	runnableCommands2
			Event.DidChangeRunnableCommand.broadcastWithSender(self)
		}
	}
//	@available(*, deprecated=1, message="AA")
//	public var runnableCommands: ValueStorage<Set<BuildCommand>> {
//		get {
//			assert(isRooted || _runnableCommands.value == [])
//			return	_runnableCommands
//		}
//	}

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
		runnableCommands2	=	[.Stop]
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
				runnableCommands2	=	[]
			case .Running:
				runnableCommands2	=	[.Stop]
			case .Done:
				//	Can do nothing at this state.
				//	Wait for resetting...
				runnableCommands2	=	[]
				break

			case .Error:
				//	Can do nothing at this state.
				//	Wait for resetting...
				runnableCommands2	=	[]
				break
			}
		}
		else {
			runnableCommands2	=	[.Build, .Clean]
		}
	}
}





