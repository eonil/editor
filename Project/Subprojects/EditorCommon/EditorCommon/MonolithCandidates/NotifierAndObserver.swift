////
////  Observer.swift
////  RFCFormalisation
////
////  Created by Hoon H. on 11/9/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
//
//
//
//
//
//
//
/////	You have to retain returning observer to keep the channel alive.
//func channel<T,U>(source:Notifier<T>, destination:T->U) -> Observer<T> {
//	let	o1	=	Observer({ destination($0); return () } as T->())
//	source.register(o1)
//	return	o1
//}
//
//
//
//
//
//
//
/////	Notifier does not retain the observer.
/////	Then if you don't keep a strong reference to
/////	the observer, it will be deallocated, and removed
/////	from this notifier.
//final class Notifier<T> {
//	var	_dests	=	[] as [Weak<Observer<T>>]
//	
//	init() {
//	}
//	deinit {
//		for o1 in _dests {
//			assert(o1.value != nil, "A nil-lised observer discovered. This is a bug.")
//			_clearNillisedElements(o1.value!._srcs, 1)
//		}
//	}
//	
//	///	There's no clean solution to hide signal from alien world.
//	///	Because we have only push call model. We need pull based model, and that
//	///	needs conccurent actor model.
//	func signal(s:T) {
//		for o1 in _dests {
//			assert(o1.value != nil, "A nil-lised observer discovered. This is a bug.")
//			o1.value!._fun(s)
//		}
//	}
//	
//	func register(o:Observer<T>) {
//		_dests.append(Weak(o))
//	}
//	func unregister(o:Observer<T>) {
//		_dests	=	_dests.filter({$0.value !== o})
//	}
//}
//
/////	Observer unregister itself from the notifier when
/////	it is going to die. Observer does not retain the
/////	notifier.
//final class Observer<T> {
//	private let	_fun	:	T->()
//	var			_srcs	=	[] as [Weak<Notifier<T>>]
//	
//	init(_ f:T->()) {
//		self._fun	=	f
//	}
//	deinit {
//		for n1 in _srcs {
//			assert(n1.value != nil, "A nil-lised notifier discovered. This is a bug.")
//			_clearNillisedElements(n1.value!._dests, 1)
//		}
//	}
//}
//
//
//
//private func _clearNillisedElements<T>(source:Array<Weak<T>>, count:Int) -> Array<Weak<T>> {
//	let	result	=	source.filter({$0.value != nil })
//	assert(result.count == source.count + 1)
//	return	result
//}
//
//
//
//
//
//
/////	Connect observer operator.
//func += <T> (left:Notifier<T>, right:Observer<T>) {
//	left.register(right)
//}
//
/////	Disconnect observer operator.
//func -= <T> (left:Notifier<T>, right:Observer<T>) {
//	left.unregister(right)
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
