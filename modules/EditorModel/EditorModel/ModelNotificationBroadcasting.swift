////
////  ModelNotificationBroadcasting.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/10/24.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//class Broadcaster {
//
//	public static func containsObserver(observer: ModelNotificationObserver) -> Bool {
//		assert(NSThread.isMainThread())
//		return	_observers.contains { $0 == _WeakObserverBox(observer: observer) }
//	}
//	public static func registerObserver(observer: ModelNotificationObserver) {
//		_observers.append(_WeakObserverBox(observer: observer))
//	}
//	public static func deregisterObserver(observer: ModelNotificationObserver) {
//		let	range	=	_observers.startIndex..<_observers.endIndex
//		for i in range.reverse() {
//			let	o	=	_observers[i]
//			precondition(o.observer != nil, "A registered observer has became `nil`, which means logic bug.")
//			if o.observer === observer {
//				_observers.removeAtIndex(i)
//				return
//			}
//		}
//		fatalError("Cannot find specified observer `\(observer)` from the registered observer list.")
//	}
//
//	///
//
//	internal func broadcast() {
//		assert(NSThread.isMainThread())
//		_broadcastLocally()
//		_broadcastGlobally()
//	}
//
//	///
//
//	private var	_observers	=	[_WeakObserverBox]()
//
//	private func _broadcastGlobally() {
//		for o in _observers {
//			assert(o.observer != nil, "A registered observer has became `nil`, which means logic bug.")
//			o.observer!.processNotification(self)
//		}
//	}
//	private func _broadcastLocally() {
//		switch self {
//		case .ApplicationNotification(let n):
//			n.broadcast()
//
//		case .WorkspaceNotification(let n):
//			n.broadcast()
//
//			//		case .FileNodeNotification(let n):
//			//			n.broadcast()
//			//
//			//		case .FileTreeNotification(let n):
//			//			n.broadcast()
//			
//		}
//	}
//}
//
//
//
//
//
//
//
//private func == (left: _WeakObserverBox, right: _WeakObserverBox) -> Bool {
//	return	left.observer === right.observer
//}
//private struct _WeakObserverBox {
//	weak var observer: ModelNotificationObserver?
//}
