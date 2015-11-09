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

public class BuildModel: ModelSubnode<WorkspaceModel>, BroadcastingModelType {

	public var workspace: WorkspaceModel {
		get {
			return	owner!
		}
	}

	///

	deinit {
	}

	///

	public let event = EventMulticast<Event>()






	
	///

	public private(set) var runnableCommands: Set<BuildCommand> = [] {
		willSet {
			assert(isRooted || runnableCommands == [])
			Event.WillChangeRunnableCommand.dualcastAsNotificationWithSender(self)
		}
		didSet {
			_runnableCommands.value	=	runnableCommands
			Event.DidChangeRunnableCommand.dualcastAsNotificationWithSender(self)
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

		assert(workspace.location != nil)
		if let u =  workspace.location {
			workspace.cargo.runBuildAtURL(u)
			assert(workspace.cargo.state == .Running)
		}

		runnableCommands	=	[.Stop]
	}
	public func runClean() {
		assert(isRooted)

		assert(workspace.location != nil)
		if let u = workspace.location {
			workspace.cargo.runCleanAtURL(u)
		}

		runnableCommands	=	[.Stop]
	}
	public func stop() {
		assert(isRooted)
		markUnimplemented()
	}






















	///

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		runnableCommands	=	[.Build, .Clean]

		Notification<CargoModel,CargoModel.Event>.register	(self, BuildModel._process)
	}
	override func willLeaveModelRoot() {
		Notification<CargoModel,CargoModel.Event>.deregister	(self)

		runnableCommands	=	[]
		super.willLeaveModelRoot()
	}








	private func _process(n: Notification<CargoModel, CargoModel.Event>) {
		guard n.sender === workspace.cargo else {
			return
		}
		switch n.event {
		case .DidChangeState:
			_applyCargoState()

		case .DidComplete:
			break

		case .DidEmitErrorLogLine:
			break

		case .DidEmitOutputLogLine:
			break

		}
	}







	///

	private let	_runnableCommands	=	MutableValueStorage<Set<BuildCommand>>([])

	private func _applyCargoState() {
		if let state = workspace.cargo.state {
			switch state {
			case .Ready:
				runnableCommands	=	[]
			case .Running:
				runnableCommands	=	[.Stop]
			case .Done:
				//	Can do nothing at this state.
				//	Wait for resetting...
				runnableCommands	=	[]
				break

			case .Error:
				//	Can do nothing at this state.
				//	Wait for resetting...
				runnableCommands	=	[]
				break
			}
		}
		else {
			runnableCommands	=	[.Build, .Clean]
		}
	}
}





