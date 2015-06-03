//
//  InternalOnlyOperators.swift
//  UIKitExtras
//
//  Created by Hoon H. on 11/26/14.
//
//

import Foundation

infix operator ||| {
//	associativity	right
}

///	Returns `a` if it is non-nil value.
///	Otherwise returns `b`.
internal func ||| <T> (a:T?, @autoclosure b:()->T) -> T {
	if let a1 = a { return a1 }
	return	b()
}