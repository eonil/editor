//
//  SwiftPatch.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 10/30/14.
//
//

import Foundation

///	Missing `enumerate` function.
func enumerate<T:GeneratorType>(g:T) -> EnumerateGenerator<T> {
	return	EnumerateGenerator<T>(g)
}




extension Array {
	init(_ elements:GeneratorOf<T>) {
		self.init()
		for e in elements {
			self.append(e)
		}
	}
	init(_ elements:LazyBidirectionalCollection<[T]>) {
		self.init()
		for e in elements {
			self.append(e)
		}
	}
}