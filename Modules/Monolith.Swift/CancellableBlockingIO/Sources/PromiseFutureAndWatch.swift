////
////  PromiseAndFuture.swift
////  EonilCancellableBlockingIO
////
////  Created by Hoon H. on 11/8/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
//
/////	Promise has no direct cancellation or progress support.
/////	It makes everything too complex. If you need it, assembly
/////	multiple promises to build it.
/////	A promise must always be fulfilled.
//public class PromiseOf<T> {
//	private var	_value		=	nil as T?		//	`nil` until the value resolved.
//	private var	_sema		=	Semaphore()
//	
//	private var	_watches	=	[] as [WeakBox<WatchOf<T>>]
//	
//	public init() {
//	}
//	deinit {
//		assert(_value != nil, "A promise is forgetting without fulfilling it! A promise must always be fulfilled.")
//	}
//	
//	private func _signalAll() {
//		while _sema.signal() > 0 {
//		}
//	}
//	private func _callWatches() {
//		for w1 in _watches {
//			w1.value!._reaction(_value!)
//		}
//		_watches.removeAll(keepCapacity: false)
//	}
//	
//	public func set(value:T) {
//		precondition(_value == nil, "You can't change result of once resolved promise.")
//		
//		_value	=	value
//		_signalAll()
//		_callWatches()
//	}
//	
//	public var future:FutureOf<T> {
//		get {
//			return	FutureOf<T>(self)
//		}
//	}
//}
//
//
//
//
//
//
//public struct FutureOf<T> {
//	private weak var	_promise	=	nil as PromiseOf<T>?
//	
//	private init(_ p:PromiseOf<T>) {
//		_promise	=	p
//	}
//	
//	public var ready:Bool {
//		get {
//			return	_promise?._value != nil
//		}
//	}
//	///	Crashes if the value is not ready.
//	public func evaluate() -> T {
//		return	_promise!._value!
//	}
//	
//	///	See `wait(duration:NSTimeInteger)` function.
//	public func wait() -> T? {
//		return	_wait(nil)
//	}
//	
//	///	Blocks the caller until the value will be set.
//	///	This uses GCD semaphores, so will not work properly
//	///	without GCD context.
//	public func wait(duration:NSTimeInterval) -> T {
//		return	_wait(duration)
//	}
//	
//	private func _wait(limit:NSTimeInterval?) -> T {
//		if _promise!._value == nil {
//			if limit == nil {
//				_promise!._sema.wait()
//			} else {
//				_promise!._sema.wait(limit!)
//			}
//		}
//		
//		return	_promise!._value!
//	}
//	
//}
//
//
//
//
//
//
//
//
//
//public final class WatchOf<T> {
//	private weak var	_promise:PromiseOf<T>?
//	private let			_reaction:T->()
//	private init(_ f:FutureOf<T>, _ reaction:T->()) {
//		_promise	=	f._promise
//		_reaction	=	reaction
//			
//		_promise!._watches.append(WeakBox<WatchOf<T>>(self))
//	}
//	deinit {
//		_promise!._watches	=	_promise!._watches.filter({$0.value !== nil})		///	Weak-references will already be nil-lised.
//	}
//}
//
/////	Watches for the promise of the future to be fulfilled or cancelled.
/////	The monitoring sustains only for the returning `WatchOf` object
/////	alive.
//public func watch<T>(future:FutureOf<T>, call:T->()) -> WatchOf<T> {
//	return	WatchOf<T>(future, call)
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
