////
////  BidirectionalSparseList.swift
////  RFCFormalisation
////
////  Created by Hoon H. on 11/10/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
////class BidirectionalSparseList<T> {
////	
////	
////}
//
//
/////	First owns its next, and the next owns its next, ... and so on.
//final class LinkListNode<T> {
//	private unowned var	_next:LinkListNode<T>
//	var	value:T
//	
//	init(_ value:T) {
//		self.value	=	value
//	}
//	
//	var	prior:LinkListNode<T>? {
//		get {
//			
//		}
//		set {
//			
//		}
//		willSet {
//			
//			if let n2 = prior {
//				n2.next		=	nil
//			}
//		}
//		didSet {
//			if let n2 = prior {
//				n2.next		=	self
//			}
//		}
//	}
//	var	next:LinkListNode<T>? {
//		willSet {
//			if let n2 = next {
//				n2.prior	=	nil
//			}
//		}
//		didSet {
//			if let n2 = next {
//				n2.prior	=	self
//			}
//		}
//	}
//}
//
//
//
//struct LinkList<T> {
//	private var _first:LinkListNode<T>?
//	private var _last:LinkListNode<T>?
//	
//	init() {
//	}
//	mutating func prepend(v:T) {
//		let	n1	=	LinkListNode(v)
//		if let f2 = _first {
//			n1.next		=	f2
//			f2.prior	=	n1
//		}
//		_first	=	n1
//	}
//	mutating func append(v:T) {
//		let	n1		=	LinkListNode(v)
//		if let l2 = _last {
//			n1.next		=	_last
//			l2.prior	=	n1
//		}
//		_last	=	n1
//	}
//}
//
//struct CountingListLink<T> {
//	var	_ll	=	LinkList<T>()
//}
//
//
//
//
//
//
