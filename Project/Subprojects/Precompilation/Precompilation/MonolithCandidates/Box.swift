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
public class Box<T> {
	public let	value:T
	public init(_ value:T) {
		self.value	=	value
	}
}

public struct Weak<T:AnyObject> {
	public weak var	value:T?
	
	public init(_ v:T) {
		self.value	=	v
	}
}



