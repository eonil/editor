//
//  Semaphore.swift
//  EonilDispatch
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

///	Treat as a reference type.
public class Semaphore : Object {
	var	rawSemaphore:dispatch_semaphore_t {
		get {
			return	raw as dispatch_semaphore_t
		}
	}

	convenience public init() {
		self.init(value: 0)
	}
	public init(value:Int) {
		super.init(dispatch_semaphore_create(value)!)
	}
	
	public func wait(time:Time) {
		dispatch_semaphore_wait(rawSemaphore, time.mapToObjc())
	}
	
	public func wait(duration:NSTimeInterval) {
		let	ns1	=	Int64(NSTimeInterval(NSEC_PER_SEC) * duration)
		let	t1	=	dispatch_time(DISPATCH_TIME_NOW, ns1)
		dispatch_semaphore_wait(rawSemaphore, t1)
	}
	
	public func signal() -> Int {
		return	dispatch_semaphore_signal(rawSemaphore)
	}
}






public enum Time {
	case Now
	case Forever
	
	func mapToObjc() -> dispatch_time_t {
		switch self {
		case .Now:		return	DISPATCH_TIME_NOW
		case .Forever:	return	DISPATCH_TIME_FOREVER
		}
	}
}

