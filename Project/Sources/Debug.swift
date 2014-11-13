//
//  Debug.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import EonilDispatch
struct Debug {
	static func log<T>(v:@autoclosure()->T) {
		let	v2	=	v()
		async(Queue.main) {
			println(v2)
		}
	}
}