//
//  Interop.swift
//  EonilDispatch
//
//  Created by Hoon H. on 11/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


public func rawObjectOf(q:Queue) -> dispatch_queue_t {
	return	q.raw
}
public func rawObjectOf(s:Source) -> dispatch_source_t {
	return	s.raw
}
public func rawObjectOf(s:Semaphore) -> dispatch_semaphore_t {
	return	s.raw
}



