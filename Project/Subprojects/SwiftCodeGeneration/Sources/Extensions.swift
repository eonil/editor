//
//  Extensions.swift
//  DataConverterClassGenerator
//
//  Created by Hoon H. on 11/16/14.
//
//

import Foundation


extension Array {
	var rest:Slice<T> {
		get {
			return	self[1..<count]
		}
	}
}

extension Slice {
	var array:Array<T> {
		get {
			return	[T](self)
		}
	}
}