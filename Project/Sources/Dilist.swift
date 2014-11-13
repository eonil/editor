////
////  Dilist.swift
////  RustCodeEditor
////
////  Created by Hoon H. on 11/13/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
////
///////	Directed doubly linked list.
///////	*Directed* means that this list has a direction of first
///////	to last. This is to break cycles.
////struct Dilist<T> {
//////	private var	first:DilistNode<T>
//////	private var	last:DilistNode<T>
////	
////	private let	_state:DilistState<T>
////}
//
//
/////	Directed doubly linked list.
/////	*Directed* means that this list has a direction of first
/////	to last. This is to break cycles.
//final class DilistNode<T> : SequenceType {
//	private weak var	_prior:DilistNode<T>?
//	private var			_next:DilistNode<T>?
//	
//	let	value:T
//	
//	var prior:DilistNode<T>? {
//		get {
//			return	_prior
//		}
//	}
//	var next:DilistNode<T>? {
//		get {
//			return	_next
//		}
//	}
//	
//	///	O(n).
//	var first:DilistNode<T> {
//		get {
//			var	n1	=	self
//			while let n2 = n1.prior {
//				n1	=	n2
//			}
//			return	n1
//		}
//	}
//	
//	///	O(n).
//	var last:DilistNode<T> {
//		get {
//			var	n1	=	self
//			while let n2 = n1.next {
//				n1	=	n2
//			}
//			return	n1
//		}
//	}
//	
//	init(_ value:T) {
//		self.value	=	value
//	}
//	
//	///	Iterates from current node to the end.
//	func generate() -> GeneratorOf<T> {
//		var	n1	=	self as DilistNode<T>?
//		return	GeneratorOf {
//			let	n2	=	n1
//			n1	=	n1!.next
//			return	n2?.value
//		}
//	}
//	
//	///	Pushing part must be a sole list which is not connected
//	///	to any other list.
//	func pushAtNext(n:DilistNode<T>) {
//		if let oldNext = _next {
//			assert(oldNext._prior === self)
//			
//			let	newLast		=	n.last
//			oldNext._prior	=	newLast
//			newLast._next	=	oldNext
//		}
//		
//		n.first._prior	=	self
//		self._next		=	n
//		
//	}
//	
////	///	Pushing part must be a sole list which is not connected
////	///	to any other list.
////	func pushAtPrior(n:DilistNode<T>) {
////		
////	}
//	
//	///	Popped part will become a sole list.
//	func popNext() -> DilistNode<T> {
//		let	n2	=	next!
//		n2.popSelf()
//		return	n2
//	}
//	
//	///	Popped part will become a sole list.
//	func popPrior() -> DilistNode<T> {
//		let	n2	=	prior!
//		n2.popSelf()
//		return	n2
//	}
//	
//	func popSelf() {
//		precondition(self.prior != nil || self.next != nil)
//		
//		if let p2 = prior {
//			p2._next	=	next
//		}
//		
//		if let n2 = next {
//			n2._prior	=	prior
//		}
//		
//		_next	=	nil
//		_prior	=	nil
//	}
//}
