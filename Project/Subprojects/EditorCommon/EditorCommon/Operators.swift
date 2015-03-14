//
//  Operators.swift
//  EditorCommon
//
//  Created by Hoon H. on 2015/02/20.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

infix operator ||| {
}

///	**DEPRECATED**
///	Will be removed from library very soon.
///
///	Use `??` that shipped with Swift standard library.
///
///	Returns `a` if it is non-nil value.
///	Otherwise returns `b`.
@availability(*,deprecated=0)
public func ||| <T> (a:T?, @autoclosure b:()->T) -> T {
	if let a1 = a {
		return a1
	}
	return	b()
}