////
////  MonitorChain.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/08/21.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import MulticastingStorage
//
//protocol SelectionChainType: class {
//	typealias	Element
//	weak var storage: ValueStorage<Element?>? { get set }
//}
//
//class SelectionTracker<T> {
//
//}
//
//class SelectionChain<T,U>: SelectionChainType {
//	init(_ route: T->ValueStorage<U>) {
//		_route	=	route
//	}
//
//	weak var storage: ValueStorage<T?>? {
//		didSet {
//			if let storage = storage {
//				if storage.value != nil {
//					_didSetStorageValue()
//				}
//				storage.registerDidSet(ObjectIdentifier(self)) { [weak self] in self!._didSetStorageValue() }
//				storage.registerWillSet(ObjectIdentifier(self)) { [weak self] in self!._willSetStorageValue() }
//			}
//		}
//		willSet {
//			if let storage = storage {
//				storage.deregisterDidSet(ObjectIdentifier(self))
//				storage.deregisterWillSet(ObjectIdentifier(self))
//				if storage.value != nil {
//					_willSetStorageValue()
//				}
//			}
//		}
//	}
//
////	var substorage: ValueStorage<U>? {
////		get {
////			guard storage != nil else {
////				return	nil
////			}
////			guard storage!.value != nil else {
////				return	nil
////			}
////			return	_route(storage!.value!)
////		}
////	}
//
//	var didSetSubstorageValue: (U->())?
//	var willSetSubstorageValue: (U->())?
//
//	weak var subchain: SelectionChainType?
//
//	///
//
//	private let	_route	:	T->ValueStorage<U>
//
//	private func _didSetStorageValue() {
//		if let v = storage!.value {
//			let	substorage	=	_route(v)
//			substorage.registerDidSet(ObjectIdentifier(self)) { [weak self, weak substorage] in self!.didSetSubstorageValue?(substorage!.value) }
//			substorage.registerWillSet(ObjectIdentifier(self)) { [weak self, weak substorage] in self!.willSetSubstorageValue?(substorage!.value) }
//		}
//	}
//	private func _willSetStorageValue() {
//		if let v = storage!.value {
//			_route(v).deregisterDidSet(ObjectIdentifier(self))
//			_route(v).deregisterWillSet(ObjectIdentifier(self))
//		}
//	}
//}
//
//
//
//
//
////
////
////class SelectionRouting<T>: SubselectionRouting<T> {
////	convenience init(_ origin: ValueStorage<T?>) {
////		self.init()
////		self.origin	=	origin
////	}
////	override init() {
////		super.init()
////	}
////	override var origin: ValueStorage<T?>? {
////		get {
////			return	super.origin
////		}
////		set {
////			super.origin	=	newValue
////		}
////	}
////}
////
////class SubselectionRouting<T> {
////	private init() {
////	}
////	deinit {
////		assert(_setSubchainOrigin == nil, "You must `dechain` before this object dies.")
////	}
////	private weak var origin: ValueStorage<T?>? {
////		didSet {
////			if let origin = origin {
////				if origin.value != nil {
////					_didSetOriginValue()
////				}
////				origin.registerDidSet(ObjectIdentifier(self)) { [weak self] in
////					self!._didSetOriginValue()
////				}
////				origin.registerWillSet(ObjectIdentifier(self)) { [weak self] in
////					self!._willSetOriginValue()
////				}
////			}
////		}
////		willSet {
////			if let origin = origin {
////				origin.deregisterDidSet(ObjectIdentifier(self))
////				origin.deregisterDidSet(ObjectIdentifier(self))
////				if origin.value != nil {
////					_willSetOriginValue()
////				}
////			}
////		}
////	}
////
////	func chain<U>(route: T->ValueStorage<U?>) -> SelectionRouting<U> {
////		assert(_setSubchainOrigin == nil)
////
////		// `subnode` is owned by this object, and will
////		// be released when you call `dechain`.
////		let	subnode		=	SelectionRouting<U>()
////		_setSubchainOrigin	=	{ [subnode] v in
////			if let v = v {
////				let	suborigin	=	route(v)
////				subnode.origin		=	suborigin
////			}
////			else {
////				subnode.origin		=	nil
////			}
////		}
////		if let v = origin?.value {
////			_setSubchainOrigin!(v)
////		}
////		return	subnode
////	}
////	func dechain() {
////		assert(_setSubchainOrigin != nil)
////
////		if let _ = origin?.value {
////			_setSubchainOrigin!(nil)
////		}
////		_setSubchainOrigin	=	nil
////	}
////
////	///
////
////	private var	_setSubchainOrigin	:	((T?)->())?
////
////	private func _didSetOriginValue() {
////		if let v = origin!.value {
////			_setSubchainOrigin?(v)
////		}
////	}
////	private func _willSetOriginValue() {
////		if let _ = origin!.value {
////			_setSubchainOrigin?(nil)
////		}
////	}
////}
////
