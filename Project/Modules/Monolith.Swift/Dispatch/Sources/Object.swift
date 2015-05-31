//
//  Object.swift
//  EonilDispatch
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

public class Object {
	let	raw:dispatch_object_t
	
	init(_ raw:dispatch_object_t) {
		self.raw	=	raw
	}
	deinit {
	}


	public func resume() {
		dispatch_resume(raw)
	}
}