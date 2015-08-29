//
//  DebuggerEventWaiter.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import EditorCommon

public class DebuggingEventWaiter: ModelSubnode<DebuggingModel> {

	public var debug: DebuggingModel {
		get {
			return	owner!
		}
	}

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_install()
	}
	override func willLeaveModelRoot() {
		_deinstall()
		super.willLeaveModelRoot()
	}

	///

	public func register(identifier: ObjectIdentifier, handler: LLDBEvent->()) {
		_handlerMappings[identifier]	=	handler
	}
	public func deregister(identifier: ObjectIdentifier) {
		_handlerMappings[identifier]	=	nil
	}

	///

	private let	_waitingQueue		=	dispatch_queue_create("Eonil/Editor Serial Queue for LLDB Debugger Event Listening", DISPATCH_QUEUE_SERIAL)
	private var	_isWaiting		=	false
	private var	_handlerMappings	=	Dictionary<ObjectIdentifier, LLDBEvent->()>()

	///

	private func _install() {
		_isWaiting			=	true
		_waitDebuggerEvents()
	}
	private func _deinstall() {
		_isWaiting			=	false
	}

	private func _waitDebuggerEvents() {
		guard _isWaiting == true else {
			return
		}

		// TODO: Non-main GCD serial queue may execute code in main thread.
		//	 We need to deal with this issue later...
		//
		let	dbg	=	debug.debugger
		dispatch_async(_waitingQueue) { [weak self] in
			Debug.assertNonMainThread()
			if let e = dbg.listener.waitForEvent(1) {
				dispatchToMainQueueAsynchronously { [weak self] in
					Debug.assertMainThread()
					self?._processEvent(e)
					self?._waitDebuggerEvents()
				}
			}
			else {
				dispatchToMainQueueAsynchronously { [weak self] in
					Debug.assertMainThread()
					self?._waitDebuggerEvents()
				}
			}
		}
	}

	private func _processEvent(e: LLDBEvent) {
		Debug.assertMainThread()
		guard _isWaiting == true else {
			return
		}
		Debug.log(e)
		for (_,v) in _handlerMappings {
			v(e)
		}
		_waitDebuggerEvents()
	}

}