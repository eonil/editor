//
//  EventMulticast.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/27.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon

public struct EventMulticast<E> {
	public func register<T: AnyObject>(object: T, _ instanceMethod: T -> E -> ()) {
		_event.register(object, instanceMethod)
	}
	public func deregister<T: AnyObject>(object: T) {
		_event.deregister(object)
	}

	public func register(identifier: ObjectIdentifier, _ function: E -> ()) {
		_event.register(identifier, function)
	}
	public func deregister(identifier: ObjectIdentifier) {
		_event.deregister(identifier)
	}

	///

//	/// Just multicast evnt only to local observers.
//	/// If you also need to cast globally, you need to use 
//	/// `Notification.dualcastWithSender()` method.
//	internal func cast(event: E) {
//		_event.cast(event)
//	}

	///

	private let	_event	=	MulticastStation<E>()
}



internal extension BroadcastableEventType where Self == Sender.Event {
	/// This method sends `self` to local event multicaster of `sender`
	/// and also to global broadcaster as a global notification. So you
	/// can receive events from both of local event observer and global
	/// observer.
	/// Always, local multicasting comes first, and global broadcasting
	/// follows.
	internal func dualcastWithSender(sender: Sender) {
//		sender.event.cat(self)
		GlobalModelLock.lockBeforeDispatchingEvent()
		sender.event._event.cast(self)
		Notification(sender, self).broadcast()
		GlobalModelLock.unlockAfterDispatchingEvent()
	}
}

