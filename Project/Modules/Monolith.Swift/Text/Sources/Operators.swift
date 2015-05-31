//
//  ops.swift
//  EDXC
//
//  Created by Hoon H. on 10/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation




///	Pipe operator works as applying a function to a value and returns a value.
func | <T,U> (left:T, right:(T)->U) -> U {
	return	right(left)
}
///	Pipe operator works as applying a function to a value.
func | <T> (left:T, right:(T)->()) {
	right(left)
}


