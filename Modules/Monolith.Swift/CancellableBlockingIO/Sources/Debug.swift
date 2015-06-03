//
//  Debug.swift
//  CancellableBlockingIO
//
//  Created by Hoon H. on 11/18/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation




struct Debug {
#if DEBUG
	static let	mode	=	true
#else
	static let	mode	=	false
#endif
	
	static func log<T>(@autoclosure v:()->T) {
		if mode {
			debugPrintln(v())
		}
	}
}