//
//  NotificationType+Broadcasting.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/24.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon









/// Defines subcategory notification type.
///
/// You cannot broadcast subcateogory notification directly.
/// But you can observe for them if one of them are notified using `ModelNotification.broadcast`.
/// The notification will be arrived **before** observer registered to `ModelNotification`.
///
public protocol NotificationType {
	static func register<T: AnyObject>(object: T, _ instanceMethod: T -> Self -> ())
	static func deregister<T: AnyObject>(object: T)

	static func register(identifier: ObjectIdentifier, _ function: Self->())
	static func deregister(identifier: ObjectIdentifier)
}

public extension NotificationType {
	/// Broadcast self globally.
	public func broadcast() {
		_cast(self)
	}

	/// Registers a global notification observer.
	public static func register<T: AnyObject>(object: T, _ instanceMethod: T -> Self -> ()) {
		_register(self, object, instanceMethod)
	}
	/// Deregisters a global notification observer.
	public static func deregister<T: AnyObject>(object: T) {
		_deregister(self, object)
	}

	/// Registers a global notification observer.
	public static func register<T>(type: T.Type, _ classMethod: Self -> ()) {
		register(ObjectIdentifier(type), classMethod)
	}
	/// Deregisters a global notification observer.
	public static func deregister<T>(type: T.Type) {
		deregister(ObjectIdentifier(type))
	}

	/// Registers a global notification observer.
	public static func register(identifier: ObjectIdentifier, _ function: Self->()) {
		_register(self, identifier, function)
	}
	/// Deregisters a global notification observer.
	public static func deregister(identifier: ObjectIdentifier) {
		_deregister(self, identifier)
	}

	///

	/// Returns non-`nil` value only if there's some registered observer.
	internal static func searchBroadcastingStation() -> MulticastStation<Self>? {
		return	_searchBroadcastingStation(self)
	}
}





















private func _searchBroadcastingStation<T: NotificationType>(_: T.Type) -> MulticastStation<T>? {
	let	typeID		=	ObjectIdentifier(T)
	let	ms		=	_mappings[typeID] as! MulticastStation<T>?
	return	ms
}



private func _cast<N: NotificationType>(instance: N) {
	let	typeID	=	ObjectIdentifier(N)
	if let mc = _mappings[typeID] {
		let	mc1	=	mc as! MulticastStation<N>
		mc1.cast(instance)
	}
}

private func _register<N: NotificationType, T: AnyObject>(type: N.Type, _ object: T, _ instanceMethod: T -> N -> ()) {
	let	typeID	=	ObjectIdentifier(type)
	if _mappings[typeID] == nil {
		_mappings[typeID]	=	MulticastStation<N>()
	}
	let	mc	=	_mappings[typeID]! as! MulticastStation<N>
	mc.register(object, instanceMethod)
}
private func _deregister<N: NotificationType, T: AnyObject>(type: N.Type, _ object: T) {
	let	typeID	=	ObjectIdentifier(type)
	let	mc	=	_mappings[typeID]! as! MulticastStation<N>
	mc.deregister(object)
	if mc.numberOfObservers == 0 {
		_mappings[typeID]	=	nil
	}
}
private func _register<N: NotificationType>(type: N.Type, _ identifier: ObjectIdentifier, _ function: N -> ()) {
	let	typeID	=	ObjectIdentifier(type)
	if _mappings[typeID] == nil {
		_mappings[typeID]	=	MulticastStation<N>()
	}
	let	mc	=	_mappings[typeID]! as! MulticastStation<N>
	mc.register(identifier, function)
}
private func _deregister<N: NotificationType>(type: N.Type, _ identifier: ObjectIdentifier) {
	let	typeID	=	ObjectIdentifier(type)
	let	mc	=	_mappings[typeID]! as! MulticastStation<N>
	mc.deregister(identifier)
	if mc.numberOfObservers == 0 {
		_mappings[typeID]	=	nil
	}
}




private var	_mappings	=	[ObjectIdentifier: AnyObject]()		//	Value type is `MulticastStation<T>`.




