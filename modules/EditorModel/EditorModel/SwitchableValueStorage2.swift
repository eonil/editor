////
////  SwitchableValueStorage2.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/23.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import MulticastingStorage
//
///// Value is set to `nil` at first.
///// When you set an origin-storage, and if the storage has non-`nil`
///// value, it will become non-`nil` value.
///// Also this tracks the origin-storage, and routes `didSet/willSet`
///// events to handlers.
/////
//public class SwitchableValueStorage2<T> {
//
//	internal weak var originStorage: ValueStorage<T?>? {
//		didSet{
//			if let originStorage = originStorage {
//				if let _ = originStorage.value {
//					_handleOriginDidSetValue()
//				}
//				originStorage.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//					self?._handleOriginDidSetValue()
//				}
//				originStorage.registerWillSet(ObjectIdentifier(self)) { [weak self] in
//					self?._handleOriginWillSetValue()
//				}
//			}
//		}
//		willSet {
//			if let originStorage = originStorage {
//				originStorage.deregisterWillSet(ObjectIdentifier(self))
//				originStorage.deregisterDidSet(ObjectIdentifier(self))
//				if let _ = originStorage.value {
//					_handleOriginWillSetValue()
//				}
//			}
//		}
//	}
//
//	///
//
//	public var value: T? {
//		get {
//			return	originStorage?.value
//		}
//	}
//
//	///
//
//	public typealias	Handlers	=	(didSet: ()->(), willSet: ()->())
//	public subscript(identifier: ObjectIdentifier) -> Handlers? {
//		get {
//			return	_handlersMap[identifier]
//		}
//		set {
//			assert(newValue == nil && _handlersMap[identifier] != nil)
//			assert(newValue != nil && _handlersMap[identifier] == nil)
//			_handlersMap[identifier]		=	newValue
//		}
//	}
//
//	///
//
//	private var		_handlersMap	=	[ObjectIdentifier: Handlers]()
//
//	///
//
//	private func _handleOriginDidSetValue() {
//		for handlers in _handlersMap.values {
//			handlers.didSet()
//		}
//	}
//	private func _handleOriginWillSetValue() {
//		for handlers in _handlersMap.values {
//			handlers.willSet()
//		}
//	}
//}
//
//
//
//
//
//
//
