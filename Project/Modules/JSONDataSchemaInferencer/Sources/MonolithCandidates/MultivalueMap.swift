////
////  MultivalueMap.swift
////  IrregularDataSchemaInferencingMachine
////
////  Created by Hoon H. on 11/16/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
//struct MultivalueMapWithTimeOrder<K:Hashable,V> {
//	var	inner	=	DictionaryWithTimeOrder<K,ArrayBox>()
//	mutating func addValueForKey(key:K, value:V) {
//		inner.valueForKey(key, setIfDoesNotExists: ArrayBox()).array.append(value)
//	}
//	mutating func removeValueForKey(key:K, value:V) {
//		inner.valueForKey(key, setIfDoesNotExists: ArrayBox()).array.
//	}
//	
//	final class ArrayBox {
//		var	array	=	[] as [V]
//	}
//}