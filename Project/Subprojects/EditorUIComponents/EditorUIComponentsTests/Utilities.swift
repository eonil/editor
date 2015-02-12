//
//  Utilities.swift
//  EditorUIComponents
//
//  Created by Hoon H. on 2015/02/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation


func runSteppingsInMainThread(steps:[()->()]) {
	assert(NSThread.currentThread() == NSThread.mainThread())
	
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
		//		sleep(1)
		dispatch_async(dispatch_get_main_queue()) {
			if let s = steps.first {
				s()
				runSteppingsInMainThread(Array(steps[steps.startIndex+1..<steps.endIndex]))
			}
		}
	}
}

