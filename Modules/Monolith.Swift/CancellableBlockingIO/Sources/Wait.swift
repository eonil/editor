//
//  Wait.swift
//  dispatch_semaphore_test
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


///	Blocks current block for the duration.
struct Wait {
	private let	_sema	=	Semaphore()
	
	let	duration:NSTimeInterval
	init(_ duration:NSTimeInterval) {
		self.duration	=	duration
	}
	
	func cancel() {
		_sema.signal()
	}
	func complete() {
		_sema.wait(duration)
	}
}