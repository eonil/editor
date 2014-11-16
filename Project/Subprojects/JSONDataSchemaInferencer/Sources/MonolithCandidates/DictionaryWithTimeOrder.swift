//
//  DictionaryWithTimeOrder.swift
//  IrregularDataSchemaInferencingMachine
//
//  Created by Hoon H. on 11/16/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation



///	Order is defined by time of new addition.
///	Replacing value does not update its order.
struct DictionaryWithTimeOrder<K:Hashable,V> : SequenceType {
	private var	inner	=	[:] as [K:V]
	private var	order	=	[] as [K]
	
	init() {
	}
//	///	Duplicated key is illegal.
//	init(_ array:[(key:K,value:V)]) {
//		items	=	array
//	}
	
	var count:Int {
		get {
			assert(inner.count == order.count)
			return	inner.count
		}
	}
	
	mutating func valueForKey(k:K, setIfDoesNotExists v: @autoclosure()->V) -> V {
		if let v2 = self[k] {
			return	v2
		} else {
			let	v2	=	v()
			self[k]	=	v2
			return	v2
		}
	}
	subscript(k:K) -> V? {
		get {
			return	inner[k]
		}
		set(v) {
			if v == nil {
				inner.removeValueForKey(k)
				order.removeAtIndex(find(order, k)!)
			} else {
				if inner[k] == nil {
					order.append(k)
				}
				inner[k]	=	v
			}
		}
	}
	
	func asArray() -> [(key:K,value:V)] {
		var	a1	=	[] as [(key:K,value:V)]
		for k in order {
			a1.append(key: k, value: inner[k]!)
		}
		return	a1
	}
	var allValues:[V] {
		get {
			return	inner.values.array
		}
	}
	var allKeys:[K] {
		get {
			return	order
		}
	}
	
	func generate() -> GeneratorOf<(key:K,value:V)> {
		var	g1	=	order.generate()
		return	GeneratorOf {
			let	k1	=	g1.next()
			return	k1 == nil ? nil : (key: k1!, value: self.inner[k1!]!)
		}
	}
}










//
/////	Order is defined by time of new addition.
/////	Replacing value does not update its order.
//struct DictionaryWithTimeOrder<K:Hashable,V> : SequenceType {
//	private var	items	=	[] as [(key:K,value:V)]
//	private var	memo	=	[:] as [K:Int]
//	
//	init() {
//	}
//	///	Duplicated key is illegal.
//	init(_ array:[(key:K,value:V)]) {
//		items	=	array
//	}
//	
//	var count:Int {
//		get {
//			return	items.count
//		}
//	}
//	
//	mutating func valueForKey(k:K, setIfDoesNotExists v: @autoclosure()->V) -> V {
//		if let v2 = self[k] {
//			return	v2
//		} else {
//			let	v2	=	v()
//			self[k]	=	v2
//			return	v2
//		}
//	}
//	subscript(k:K) -> V? {
//		get {
//			if let idx = memo[k] {
//				return	items[idx].value
//			}
//			for m in items {
//				if m.key == k {
//					return	m.value
//				}
//			}
//			return	nil
//		}
//		set(v) {
//			func indexForKey(k:K) -> Int? {
//				for i in 0..<items.count {
//					if items[i].key == k {
//						return	i
//					}
//				}
//				return	nil
//			}
//			
//			let	i	=	indexForKey(k)
//			
//			switch (i,v) {
//			case (nil,nil):
//				//	Remove non-existing. Doesn't make sense.
//				fatalError("Cannot find a key for the value.")
//			case (nil,_):
//				//	Add new.
//				memo[k]	=	items.count
//				items.append(key:k, value:v!)
//			case (_,nil):
//				//	Remove existing.
//				if i! == items.count-1 {
//					items.removeLast()
//					memo.removeValueForKey(k)
//				} else {
//					items.removeAtIndex(i!)
//					memo.removeAll(keepCapacity: true)
//				}
//			case (_,_):
//				//	Replace existing.
////				items[i!].value	=	v!
//				items[i!]	=	(key:k, value:v!)
//				memo[k]		=	i!
//			}
//		}
//	}
//	
//	func asArray() -> [(key:K,value:V)] {
//		return	items
//	}
//	
//	func generate() -> GeneratorOf<(key:K,value:V)> {
//		return	GeneratorOf(items.generate())
//	}
//}
//














