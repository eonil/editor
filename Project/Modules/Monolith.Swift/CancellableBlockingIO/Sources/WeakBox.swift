//
//  WeakBox.swift
//  EonilCancellableBlockingIO
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

public struct WeakBox<T:AnyObject> {
	public var	value	=	nil as T?
	
	public init(_ v:T?) {
		value	=	v
	}
}