//
//  Debug.swift
//  IrregularDataSchemaInferencingMachine
//
//  Created by Hoon H. on 11/16/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

struct Debug {
#if	DEBUG
	static let	mode	=	true
	#else
	static let	mode	=	false
#endif
	
	static func log<T>(v:@autoclosure()->T) {
		if mode {
			println(v())
		}
	}
}