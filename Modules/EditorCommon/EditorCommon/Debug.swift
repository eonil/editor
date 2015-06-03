//
//  Debug.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation



///	Collection of features that are available only on DEBUG build, and to be stripped off
///	in RELEASE build.
public struct Debug {
	public static func logOnMainQueueAsynchronously<T>(@autoclosure v:()->T) {
		let	v2	=	v()
		dispatch_async(dispatch_get_main_queue()) {
			Debug.log(v2)
		}
	}
	public static func log<T>(@autoclosure v:()->T) {
		#if DEBUG
			println(v())
		#endif
	}
	
	public static func assertMainThread() {
		assert(NSThread.currentThread() == NSThread.mainThread())
	}
}







