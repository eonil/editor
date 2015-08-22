//
//  SwitchableValueStorage.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/22.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage

/// Value is set to `nil` at first.
/// When you set an origin-storage, and if the storage has non-`nil`
/// value, it will become non-`nil` value.
/// Also this tracks the origin-storage, and routes `didSet/willSet`
/// events to handlers.
///
public class SwitchableValueStorage<T> {

	internal weak var originStorage: ValueStorage<T?>? {
		didSet{
			if let originStorage = originStorage {
				if let _ = originStorage.value {
					_handleOriginDidSetValue()
				}
				originStorage.registerDidSet(ObjectIdentifier(self)) { [weak self] in
					self?._handleOriginDidSetValue()
				}
				originStorage.registerWillSet(ObjectIdentifier(self)) { [weak self] in
					self?._handleOriginWillSetValue()
				}
			}
		}
		willSet {
			if let originStorage = originStorage {
				originStorage.deregisterWillSet(ObjectIdentifier(self))
				originStorage.deregisterDidSet(ObjectIdentifier(self))
				if let _ = originStorage.value {
					_handleOriginWillSetValue()
				}
			}
		}
	}

	///

	public var value: T? {
		get {
			return	originStorage?.value
		}
	}

	public func registerDidSet(identifier: ObjectIdentifier, handler: ()->()) {
		assert(_handlerMaps.didSet[identifier] == nil)
		_handlerMaps.didSet[identifier]		=	handler
	}
	public func registerWillSet(identifier: ObjectIdentifier, handler: ()->()) {
		assert(_handlerMaps.willSet[identifier] == nil)
		_handlerMaps.willSet[identifier]	=	handler
	}
	public func deregisterDidSet(identifier: ObjectIdentifier) {
		assert(_handlerMaps.didSet[identifier] != nil)
		_handlerMaps.didSet[identifier]		=	nil
	}
	public func deregisterWillSet(identifier: ObjectIdentifier) {
		assert(_handlerMaps.willSet[identifier] != nil)
		_handlerMaps.willSet[identifier]	=	nil
	}

	///

	private typealias	_Handler	=	()->()
	private var		_handlerMaps	=	(didSet: [ObjectIdentifier: _Handler](), willSet: [ObjectIdentifier: _Handler]())

	///

	private func _handleOriginDidSetValue() {
		for handler in _handlerMaps.didSet.values {
			handler()
		}
	}
	private func _handleOriginWillSetValue() {
		for handler in _handlerMaps.willSet.values {
			handler()
		}
	}
}




