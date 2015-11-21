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


	public enum Span {
		case BuildOutput(String)
		case BuildError(String)
		case ExecutionOutput(String)
		case ExecutionError(String)
	}







	///

	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	public let	event	=	EventMulticast<Event>()






	///

	public private(set) var log: [Span] = []

	public func clear() {
		log	=	[]
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
		case .Subevent(_):	break
		case .Reset:		break
		case .Output(let s):	_appendSpan(Span.BuildOutput(s))
		case .Error(let s):	_appendSpan(Span.BuildError(s))
		}
	}


	private func _appendSpan(s: Span) {
		log.append(s)
		Event.DidAppendSpan(s).dualcastAsNotificationWithSender(self)
	}
}












