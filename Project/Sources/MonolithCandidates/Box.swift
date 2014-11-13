//
//  Box.swift
//  Github
//
//  Created by Hoon H. on 10/27/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


///	Provides referential identity to a value-type or function.
///	You can make implicit box using closures but it does not 
///	provide identity comparison.
class Box<T> {
	let	value:T
	init(_ value:T) {
		self.value	=	value
	}
}

struct Weak<T:AnyObject> {
	weak var	value:T?
	
	init(_ v:T) {
		self.value	=	v
	}
}



