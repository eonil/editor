//
//  ops.swift
//  EDXC
//
//  Created by Hoon H. on 10/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

//prefix operator ~~~ {
//	
//}
//
//prefix func ~~~ (follower:String) -> Pattern {
//	return	Patterns.Literal(sample: follower)
//}





infix operator ||| {

}

func ||| <T> (left:T?, right:T) -> T {
	if left == nil {
		return	right
	} else {
		return	left!
	}
}



///	Pipe operator works as applying a function to a value and returns a value.
func | <T,U> (left:T, right:(T)->U) -> U {
	return	right(left)
}
///	Pipe operator works as applying a function to a value.
func | <T> (left:T, right:(T)->()) {
	right(left)
}


//protocol Summable {
//	typealias	SelfType
//	func summationWith(other:SelfType) -> SelfType
//}
//
////func + <T:Summable> (left:T, right:T) -> T {
////	return	left.summationWith(right)
////}
//
//extension Array {
//	var rest:Slice<T>? {
//		get {
//			return	self[1..<count]
//		}
//	}
//}
