//
//  Diff.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/11.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

///	Inputs are unordered.
///	Outputs are ordered in order of `from` first, and `to next.
public func resolveDifferences<T:Hashable>(from:[T], to:[T]) -> (stays:[T], incomings:[T], outgoings:[T]) {
	var	ss	=	[] as [DiffState<T>]
	var	m	=	[:] as [T:Int]
	
	for v in from {
		let	s	=	DiffState(value: v, from: true, to: false);
		m[v]	=	ss.count
		ss.append(s)
	}
	
	for v in to {
		if let idx = m[v] {
			//	Was in `from`.
			var	s	=	ss[idx]
			s.to	=	true
			ss[idx]	=	s
		} else {
			//	Was not in `from`.
			let	s	=	DiffState(value: v, from: false, to: true)
			ss.append(s)
		}
	}
	
	var	nochanges	=	[] as [T]
	var	comes		=	[] as [T]
	var	gones		=	[] as [T]
	for s in ss {
		switch (s.from, s.to) {
		case (true, true):
			nochanges.append(s.value)
		case (true, false):
			gones.append(s.value)
		case (false, true):
			comes.append(s.value)
		default:
			fatalError("Logic bug.")
		}
	}
	return	(nochanges, comes, gones)
}


private struct DiffState<T> {
	var	value:T
	var	from:Bool
	var	to:Bool
}





































///	MARK:
///	MARK:	Unit Tests

extension UnitTest {
	private static func run(f:()->()) {
		f()
	}
	static func testDiff() {
		run {
			let	from	=	[1,2,3,4,5]
			let	to		=	[3,4,5,6,7]
			let	r		=	resolveDifferences(from, to)
			assert(r.stays == [3,4,5])
			assert(r.incomings == [6,7])
			assert(r.outgoings == [1,2])
		}
		run {
			let	from	=	[5,4,3,2,1]
			let	to		=	[3,4,5,6,7]
			let	r		=	resolveDifferences(from, to)
			assert(r.stays == [5,4,3])
			assert(r.incomings == [6,7])
			assert(r.outgoings == [2,1])
		}
	}
}

















