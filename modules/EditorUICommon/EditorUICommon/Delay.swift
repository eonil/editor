//
//  Delay.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public func delay(duration: NSTimeInterval, function: ()->()) {
	assert(NSThread.isMainThread())

	let	delta	=	Int64(NSTimeInterval(NSEC_PER_SEC) * duration)
	let	when	=	dispatch_time(DISPATCH_TIME_NOW, delta)
	dispatch_after(when, dispatch_get_main_queue(), function)
}
