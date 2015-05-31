//
//  Semaphore.swift
//  dispatch_semaphore_test
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


///	Treat as a reference type.
struct Semaphore {
	private let	_raw:dispatch_semaphore_t		///	Seems using Swift native RC.
	init() {
		_raw	=	dispatch_semaphore_create(0)!
	}
	func wait() {
		dispatch_semaphore_wait(_raw, DISPATCH_TIME_FOREVER)
	}
	func wait(duration:NSTimeInterval) {
		let	ns1	=	Int64(NSTimeInterval(NSEC_PER_SEC) * duration)
		let	t1	=	dispatch_time(DISPATCH_TIME_NOW, ns1)
		dispatch_semaphore_wait(_raw, t1)
	}
	func signal() -> Int {
		return	dispatch_semaphore_signal(_raw)
	}
}

func === (left:Semaphore, right:Semaphore) -> Bool {
	return	left._raw === right._raw
}


