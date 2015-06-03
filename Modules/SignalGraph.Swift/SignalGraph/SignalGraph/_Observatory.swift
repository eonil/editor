////
////  Observation.swift
////  SignalGraph
////
////  Created by Hoon H. on 2015/05/05.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//
//
//
//
//
//struct Observatory<T: Identifiable> {
//	mutating func register(observer: T) {
//		observers.append(observer)
//	}
//	mutating func deregister(observer: T) {
//		for i in reverse(0..<observers.count) {
//			if observers[i] === observer {
//				observers.removeAtIndex(i)
//			}
//		}
//	}
//	
//	private var	observers	=	[] as [T]
//}
//
//
//
//
//
//
//
//
///////	Copy-on-write implementation to avoid undesired `mutating` from outer wrapper.
////private final class ObservatoryCore<T: Identifiable> {
////	private var	observers: Box<[T]> = Box([])
////	private func ensureUniqueness() {
////		var	os	=	observers
////		if isUniquelyReferenced(&os) == false {
////			observers	=	Box(observers.value)
////		}
////	}
////}
////
////private final class Box<T>: NonObjectiveCBase {
////	init(_ value: T) {
////		_value	=	value
////	}
////	var value: T {
////		get {
////			return	_value
////		}
////		set(v) {
////			_value
////		}
////	}
////	func ensureUniqueness() {
////		isunique
////	}
////	
////	private var	_value: T
////
////	private func assertUniqueReferencing() {
////		assert(isUniquelyReferenced(&self))
////	}
////}