//
//  ListenerController.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/04.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import EditorCommon

public protocol ListenerControllerDelegate: class {
	///	Called when the debugger has stopped for a event.
	///	Target process is stopped, and won't resume until you call `continue`
	///	explicitly.
	///
	///	This will be called in main thread.
	func listenerControllerIsProcessingEvent(e:LLDBEvent)
}

///	Manages event handling in separated thread and route them back to main thread.
///	Set delegate to get notified for events.
///
///	YOU MUST SET A DELEGATE!
///	This object will crash if you have no delegate set when an event fires.
public final class ListenerController {
	public weak var delegate:ListenerControllerDelegate? {
		get {
			return	_core.delegate
		}
		set(v) {
			_core.delegate	=	v
		}
	}
	
	public init() {
		_core	=	Core()
	}
	deinit {
	}
	
	public var listener:LLDBListener {
		get {
			return	_core.listener
		}
	}
	public func startListening() {
		assert(self.delegate != nil)
		
		let	core	=	_core
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { [unowned self] in
			var	cont	=	true
			while cont {
				let	WAIT_SECONDS	=	1
				if let e = core.listener.waitForEvent(WAIT_SECONDS) {
					///	Wait for main thread processing done.
					dispatch_sync(dispatch_get_main_queue()) { [unowned self] in
						Debug.log(e)
						core.delegate!.listenerControllerIsProcessingEvent(e)
						cont	=	core.done == false
						()
					}
				}
			}
			dispatch_sync(dispatch_get_main_queue()) { [unowned self] in
				Debug.log("ListenerController exited.")
			}
		}
	}
	public func stopListening() {
		_core.done	=	true
	}
	
	////
	
	private let	_core:Core
//	private var	_done:Bool
}

private final class Core {
	weak var delegate:ListenerControllerDelegate? {
		willSet {
			precondition(delegate == nil, "Set `nil` to `delegate` first before setting a new delegate to express your intention clearly.")
		}
	}
	
	let listener	=	LLDBListener(name: "Eonil/Editor LLDB Main Listener")
	var	done		=	false
	
	init() {
	}
	deinit {
		assert(done == true, "This `ListenerController`'s listening thread has not been marked as finished. Call `stopListening` first.")
	}
}

