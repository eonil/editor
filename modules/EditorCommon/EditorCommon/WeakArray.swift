//
//  WeakArray.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

/// An array that keeps weak reference to contained objects.
///
/// This array assumes you will keep the object alive while they
/// are contained in this array. If any object goes away, this will
/// crash.
///
public struct WeakArray<T: AnyObject> {

	public init() {
	}
	public subscript(index: Int) -> T {
		get {
			assert(_array[index].object != nil)
			return	_array[index].object!
		}
	}
	public mutating func append(o: T) {
		_array.append(Weak(o))
	}
	public mutating func extend<S: SequenceType where S.Generator.Element == T>(os: S) {
		_array.extend(os.map({Weak($0)}))
	}
	public mutating func extend<C: CollectionType where C.Generator.Element == T>(os: C) {
		_array.extend(os.map({Weak($0)}))
	}
	public mutating func insert(o: T, atIndex index: Int) {
		_array.insert(Weak(o), atIndex: index)
	}
	public mutating func removeAtIndex(index: Int) -> T {
		assert(_array.removeAtIndex(index).object != nil)
		return	_array.removeAtIndex(index).object!
	}
	public mutating func removeRange(range: Range<Int>) {
		assert(_array.map({ $0.object }).filter({ $0 == nil }).count == 0)
		return	_array.removeRange(range)
	}


	///

	private var	_array	=	[Weak<T>]()
}