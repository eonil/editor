//
//  Functions.swift
//  EonilDispatch
//
//  Created by Hoon H. on 11/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation



public func async(queue:Queue, f:()->()) {
	dispatch_async(queue.raw, f)
}
public func sync(queue:Queue, f:()->()) {
	dispatch_sync(queue.raw, f)
}