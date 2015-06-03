//
//  Atomics.swift
//  dispatch_semaphore_test
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation





///	A wrapper for `OSAtomic` stuffs.
public final class AtomicInt32Slot {
	private let	_ptr:UnsafeMutablePointer<Int32>
	
	public init(_ value:Int32) {
		_ptr	=	UnsafeMutablePointer<Int32>.alloc(1)
		_ptr.initialize(value)
	}
	deinit {
		_ptr.destroy()
		_ptr.dealloc(1)
	}
	public var	value:Int32 {
		get {
			return	_ptr.memory
		}
	}
	
	///	:returns: `true` on a match, `false` otherwise.
	public func compareAndSwapBarrier(#oldValue: Int32, newValue: Int32) -> Bool {
		return	OSAtomicCompareAndSwapIntBarrier(oldValue, newValue, _ptr)
	}
}


///	A wrapper for `OSAtomic` stuffs.
public final class AtomicBoolSlot {
	let	int32:AtomicInt32Slot
	public init(_ value:Bool) {
		int32	=	AtomicInt32Slot(value ? 1 : 0)
	}
	public var value:Bool {
		get {
			return	int32.value == 1
		}
	}
	///	Returns `true` on a match, `false` otherwise.
	public func compareAndSwapBarrier(#oldValue: Bool, newValue: Bool) -> Bool {
		return	int32.compareAndSwapBarrier(oldValue: oldValue ? 1 : 0, newValue: newValue ? 1 : 0)
	}
}


///	Provide referential identity to atomic boolean slot.
public func === (left:AtomicBoolSlot, right:AtomicBoolSlot) -> Bool {
	return	left.int32 === right.int32
}








