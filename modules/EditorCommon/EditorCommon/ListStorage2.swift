////
////  ListStorage.swift
////  EditorCommon
////
////  Created by Hoon H. on 2015/11/04.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//public class MutableListStorage<T>: ListStorage<T> {
//	public func insert(element: T, at index: Int) {
//		insert([element], at: index)
//	}
//	public func insert<C: CollectionType where C.Generator.Element == T, C.Index == Int>(elements: C, at index: Int) {
//		let	range	=	index..<(index + elements.count)
//		state.insertContentsOf(elements, at: index)
//		if _onDidBeginValue.numberOfObservers > 0 {
//			for v in elements {
//				_onDidBeginValue.cast(v)
//			}
//		}
//		if _onDidBeginValuesInRange.numberOfObservers > 0 {
//			_onDidBeginValuesInRange.cast(range)
//		}
//	}
////	public func update(at index: Int, element: T) {
////		state[index]	=	element
////	}
//	public func delete(at index: Int) {
//		delete(index...index)
//	}
//	public func delete(range: Range<Int>) {
//		if _onWillEndValuesInRange.numberOfObservers > 0 {
//			_onWillEndValuesInRange.cast(range)
//		}
//		if _onWillEndValue.numberOfObservers > 0 {
//			for v in state[range].reverse() {
//				_onWillEndValue.cast(v)
//			}
//		}
//		state.removeRange(range)
//	}
//}
//public class ListStorage<T> {
//
//	public init(_ state: [T]) {
//		self.state	=	state
//	}
//
//	public private(set) var state: [T]
//
//	public var onDidBeginValue: MulticastChannel<T> {
//		get {
//			return	_onDidBeginValue
//		}
//	}
//	public var onWillEndValue: MulticastChannel<T> {
//		get {
//			return	_onWillEndValue
//		}
//	}
//	public var onDidBeginValuesInRange: MulticastChannel<Range<Int>> {
//		get {
//			return	_onDidBeginValuesInRange
//		}
//	}
//	public var onWillEndValuesInRange: MulticastChannel<Range<Int>> {
//		get {
//			return	_onWillEndValuesInRange
//		}
//	}
//
//	///
//
//	private let	_onDidBeginValue		=	MulticastStation<T>()
//	private let	_onWillEndValue			=	MulticastStation<T>()
//
//	private let	_onDidBeginValuesInRange	=	MulticastStation<Range<Int>>()
//	private let	_onWillEndValuesInRange		=	MulticastStation<Range<Int>>()
//}
//
//
//
//
//
//
