//
//  SwitchAndWatch.swift
//  EonilCancellableBlockingIO
//
//  Created by Hoon H. on 11/8/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


public final class Trigger {
	private var	_flag		=	AtomicBoolSlot(false)
	private var	_watches	=	[] as [WeakBox<Watch>]
	private let	_sync		=	NSLock()
	
	public init() {
	}
	public var state:Bool {
		get {
			return	_flag.value
		}
	}
	
	///	Becomes no-op after once set.
	public func set() {
		Debug.log("Cancellation triggered.")
		if _flag.compareAndSwapBarrier(oldValue: false, newValue: true) {
			for w1 in _watches {
				w1.value!._f()
			}
		}
	}
	
	public final class Watch {
		private let	_f:()->()
		private let	_t:Trigger
		private init(_ f:()->(), _ t:Trigger) {
			self._f	=	f
			self._t	=	t
			
			_t._sync.lock()
			_t._watches.append(WeakBox(self))
			_t._sync.unlock()
		}
		deinit {
			_t._sync.lock()
			_t._watches	=	_t._watches.filter {$0.value != nil}
			_t._sync.unlock()
		}
	}
}

public extension Trigger {
	///	Watches for this trigger and runs supplied function
	///	when the trigger triggers.
	public func watch(f:()->()) -> Watch {
		return	Watch(f, self)
	}
}
