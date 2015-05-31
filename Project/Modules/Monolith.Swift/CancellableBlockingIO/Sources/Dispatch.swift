//
//  Dispatch.swift
//  dispatch_semaphore_test
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

struct Dispatch {
	static func main(p:()->()) {
		dispatch_async(dispatch_get_main_queue(), p)
	}
	static func backgroundConcurrently(p:()->()) {
		dispatch_async(defaultGlobalBackgroundQueue(), p)
	}
	
	
	static func defaultGlobalBackgroundQueue() -> dispatch_queue_t {
		return	dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
	}
}


func background(p:()->()) {
	Dispatch.backgroundConcurrently(p)
}






