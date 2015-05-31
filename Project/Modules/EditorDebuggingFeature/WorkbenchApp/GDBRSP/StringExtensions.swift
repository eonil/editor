//
//  StringExtensions.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

extension String {
	init?(UTF8CodeUnits: [U8U]) {
		self	=	""
		
		var	de	=	UTF8()
		var	g	=	UTF8CodeUnits.generate()
		
		var	c	=	true
		while c {
			switch de.decode(&g) {
			case .Error:
				return	nil
				
			case .EmptyInput:
				c	=	false
				
			case .Result(let s):
				self.append(s)
			}
		}
	}
}