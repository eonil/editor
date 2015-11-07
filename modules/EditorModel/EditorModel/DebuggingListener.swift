//
//  DebuggingListener.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/20.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import EditorCommon

/// A wrapper around `LLDBListener` to provide simpler
/// event waiting and hide thread management.
///
class DebuggingListener {

	var onEvent: (LLDBEvent->())?

	var listener: LLDBListener {
		get {
			return	_lldbListener
		}
	}

	func run() {
		_run()
	}
	func halt() {
		_halt()
	}

	///

	private let	_lldbListener	=	LLDBListener(name: "Eonil/Editor LLDB Main Listern")
	private let	_waitingQueue	=	dispatch_queue_create("Eonil/Editor Serial Queue for LLDB Listener Waiting", DISPATCH_QUEUE_SERIAL)
	private var	_isRunning	=	AtomicBool(false)

	///

	private func _run() {
		Debug.assertMainThread()
		assert(_isRunning.state == false)
		_isRunning.state	=	true
		dispatch_async(_waitingQueue) { [weak self] in
			self?._waitInNonMainThread()
		}
	}

	private func _halt() {
		Debug.assertMainThread()
		assert(_isRunning.state == true)
		_isRunning.state	=	false
	}

	private func _waitInNonMainThread() {
		Debug.assertNonMainThread()
		if let e = _lldbListener.waitForEvent(1) {
			Debug.log("CATCHED LLDB EVENT!! \(e)")
			dispatch_async(dispatch_get_main_queue()) { [weak self] in
				// Dispose event if self is already dead.
				self?._processEventInMainThread(e)
			}
		}
		else {
			// Timeout.
		}

		guard _isRunning.state == true else {
			return
		}

		///	Wait again!
		dispatch_async(_waitingQueue) { [weak self] in
			self?._waitInNonMainThread()
		}
	}
	private func _processEventInMainThread(e: LLDBEvent) {
		Debug.assertMainThread()
		guard _isRunning.state == true else {
			return
		}
		assert(onEvent != nil)
		onEvent?(e)
	}

}






















