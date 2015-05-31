//
//  EditableArrayStorage.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//



///	A directly writable replicating array storage.
public class EditableArrayStorage<T>: ReplicatingArrayStorage<T> {
	public init(_ state: [T] = []) {
		super.init()
		editor.initiate()
	}
	deinit {
		editor.terminate()
	}
	
	private var editor: ArrayEditor<T> {
		get {
			return	ArrayEditor(self)
		}
		set(v) {
			assert(v.origin === self)
		}
	}
}
extension EditableArrayStorage {
//	public var startIndex: Int { get }
//	public var endIndex: Int { get }
//	public var count: Int { get }
//	public var isEmpty: Bool { get }
//	public var first: T? { get }
//	public var last: T? { get }
	
//	public subscript (index: Int) -> T
//	public subscript (subRange: Range<Int>) -> ArraySlice<T>
//	
//	public func generate() -> IndexingGenerator<[T]> {
//		return	state.generate()
//	}
	
	public func append(newElement: T) {
		editor.append(newElement)
	}
	public func extend<S : SequenceType where S.Generator.Element == T>(newElements: S) {
		editor.extend(newElements)
	}
	public func removeLast() -> T {
		return	editor.removeLast()
	}
	public func insert(newElement: T, atIndex i: Int) {
		editor.insert(newElement, atIndex: i)
	}
	public func removeAtIndex(index: Int) -> T {
		return	editor.removeAtIndex(index)
	}
	public func removeAll() {
		editor.removeAll()
	}
	public func replaceRange<C : CollectionType where C.Generator.Element == T>(subRange: Range<Int>, with newElements: C) {
		editor.replaceRange(subRange, with: newElements)
	}
	public func splice<S : CollectionType where S.Generator.Element == T>(newElements: S, atIndex i: Int) {
		editor.splice(newElements, atIndex: i)
	}
	public func removeRange(subRange: Range<Int>) {
		editor.removeRange(subRange)
	}

}


























