//
//  DispatchUtility.swift
//  EditorCommon
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public func dispatchToMainQueueAsynchronously(function: ()->()) {
	dispatch_async(dispatch_get_main_queue(), function)
}

public func dispatchToMainQueueSynchronously(function: ()->()) {
	dispatch_sync(dispatch_get_main_queue(), function)
}

public func dispatchToNonMainQueueAsynchronously(code: ()->()) {
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
		if NSThread.isMainThread() {
			// Try again until we get a non-main thread...
			dispatchToNonMainQueueAsynchronously(code)
		}
		else {
			code()
		}
	}
}

public func dispatchToSleepAndContinueInMainQueue(duration: NSTimeInterval, code: ()->()) {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * NSTimeInterval(NSEC_PER_SEC))), dispatch_get_main_queue(), code)
}

public func dispatchToSleepAndContinueInNonMainQueue(duration: NSTimeInterval, code: ()->()) {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * NSTimeInterval(NSEC_PER_SEC))), dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), code)
}


