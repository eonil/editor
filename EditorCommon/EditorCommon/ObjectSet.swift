//
//  ObjectSet.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

///	A set that uses reference equality to compare equality of two objects.
public struct ObjectSet<T: AnyObject>: SequenceType {

	public init() {
		_set	=	Set<_RefBox<T>>()
	}
	public var count: Int {
		get {
			return	_set.count
		}
	}
	public func contains(o: T) -> Bool {
		return	_set.contains(_RefBox(ref: o))
	}
	public func generate() -> AnyGenerator<T> {
		var	g	=	_set.generate()
		return	anyGenerator { ()->T? in
			return	g.next()?.ref
		}
	}
	public mutating func insert(o: T) {
		_set.insert(_RefBox(ref: o))
	}
	public mutating func remove(o: T) -> T? {
		return	_set.remove(_RefBox(ref: o))?.ref
	}
	public mutating func removeAll(keepCapacity: Bool) {
		_set.removeAll(keepCapacity: keepCapacity)
	}
	public mutating func removeAll() {
		_set.removeAll()
	}

	///

	private var	_set	=	Set<_RefBox<T>>()
}

private struct _RefBox<T: AnyObject>: Equatable, Hashable {
	let	ref: T

	var hashValue: Int {
		get {
			return	ObjectIdentifier(ref).hashValue
		}
	}
}
private func == <T> (a: _RefBox<T>, b: _RefBox<T>) -> Bool {
	return	a.ref === b.ref
}