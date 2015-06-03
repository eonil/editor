////
////  Cancellable.swift
////  EonilCancellableBlockingIO
////
////  Created by Hoon H. on 11/7/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
//
/////	Monitors flag and trigger cancellation procedure.
/////	One object can provide single cancellation notification.
/////	Because ther can be only one active context on blocking execution.
/////	If you're using multiple active context, use multiple cancellation
/////	object.
//public final class Cancellation {
//	let	flag		=	AtomicBoolSlot(false)
//	let	semaphore	=	Semaphore()
//	var	observer	=	nil as (()->())?
//	
//	public init() {
//		Dispatch.backgroundConcurrently { () -> () in
//			self.semaphore.wait()
//			self.observer?()
//		}
//	}
//	deinit {
//		assert(observer == nil, "Supplied observer must be cleared before this object dies. If something's still there, it's a bug.")
//	}
//	
//	public func signalCancel() {
//		if flag.compareAndSwapBarrier(oldValue: false, newValue: true) {
//			semaphore.signal()
//		}
//	}
//
//	public func setObserver(observer:()->()) {
//		assert(self.observer == nil, "An observer is currently set to some value. This should be cleared before setting a new value. Seems previous operation didn't cleared it's observer.")
//		self.observer	=	observer
//	}
//	public func unsetObserver() {
//		self.observer	=	nil
//	}
//}
//
//
//
//
//
//
