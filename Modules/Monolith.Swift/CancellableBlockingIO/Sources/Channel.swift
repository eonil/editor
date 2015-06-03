//
//  Channel.swift
//  dispatch_semaphore_test
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


///	Single-shot data transfer.
struct Transfer<T> {
	let	_s	=	Semaphore()
	var	_v	=	nil as T?
	var	_f	=	AtomicBoolSlot(false)
	
	mutating func signal(v:T) {
		assert(_f.value == false, "This is one-time use only object. Do not reuse this.")
		
		if _f.compareAndSwapBarrier(oldValue: false, newValue: true) {
			_v	=	v
			_s.signal()
		}
	}
	mutating func wait() -> T {
		_s.wait()
		assert(_v != nil)
		return	_v!
	}
}


/////	Multi-shot data transfer using sigle semaphore.
/////	Anyway this uses locking due to risk of parallel access to the value.
//struct Channel<T> {
//	let	_put	=	Semaphore()
//	let	_took	=	Semaphore()
//	var	_vals	=	[] as [T]
//	
//	init() {
//		_took.signal()
//	}
//	mutating func signal(v:T) {
//		_took.wait();
//		_vals.append(v)
//		_put.signal()
//	}
//	mutating func wait() -> T {
//		_put.wait()
//		let	v1	=	_vals.removeAtIndex(0)
//		_took.signal()
//		return	v1
//	}
//}



///	Multi-shot data transfer using sigle semaphore.
///	Anyway this uses locking due to risk of parallel access to the value.
class Channel<T> {
	let	_lock	=	NSLock()
	let	_s		=	Semaphore()
	var	_vals	=	[] as [T]
	
	func signal(v:T) {
		_lock.lock()
		_vals.append(v)
		_lock.unlock()
		_s.signal()
	}
	func wait() -> T {
		_s.wait()
		_lock.lock()
		let	v1	=	_vals.removeAtIndex(0)
		_lock.unlock()
		return	v1
	}
}

