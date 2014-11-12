//
//  Set.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

struct Set<T:Hashable> : SequenceType {
	private var	_map	=	[:] as [T:()]
	var count:Int {
		get {
			return	_map.count
		}
	}
	mutating func add(value:T) {
		_map[value]	=	()
	}
	mutating func remove(value:T) {
		_map.removeValueForKey(value)
	}
	
	func generate() -> GeneratorOf<T> {
		return	GeneratorOf<T>(_map.keys.generate())
	}
}

func += <T:Hashable> (inout left:Set<T>, right:T) {
	left.add(right)
}
func -= <T:Hashable> (inout left:Set<T>, right:T) {
	left.remove(right)
}

func += <T:Hashable> (inout left:Set<T>, right:Set<T>) {
	for v in right {
		left.add(v)
	}
}
func -= <T:Hashable> (inout left:Set<T>, right:Set<T>) {
	for v in right {
		left.remove(v)
	}
}
