//
//  ConsoleModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

public class ConsoleModel: ModelSubnode<WorkspaceModel>, BroadcastingModelType {
	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	public let	event	=	EventMulticast<Event>()






	///

	public private(set) var outputLines: [String] = []

	public func clear() {
		outputLines	=	[]
		Event.DidClear.dualcastAsNotificationWithSender(self)
	}






	///

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_install()
	}
	override func willLeaveModelRoot() {
		_deinstall()
		super.willLeaveModelRoot()
	}




	///

	private func _install() {
		Notification<CargoModel, CargoModel.Event>.register	(self, ConsoleModel._process)
	}
	private func _deinstall() {
		Notification<CargoModel, CargoModel.Event>.deregister	(self)
	}


	private func _process(n: Notification<CargoModel, CargoModel.Event>) {
		guard n.sender === workspace.cargo else {
			return
		}
		switch n.event {
		case .DidChangeState: 			break
		case .DidComplete: 			break
		case .DidEmitOutputLogLine(let line):	_appendLine(line)
		case .DidEmitErrorLogLine(let line):	_appendLine(line)
		}
	}


	private func _appendLine(line: String) {
		outputLines.append(line)
		Event.DidAppendLine.dualcastAsNotificationWithSender(self)
	}
}












