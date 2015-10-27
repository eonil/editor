////
////  NotificationType+Broadcasting2.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/10/25.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import EditorCommon
//
//public extension NotificationType {
//	public static func register<T: AnyObject>(object: T, _ instanceMethod: T->Self->()) {
//		let	callback	=	{ [weak object] (n:Self)->() in
//			guard let object = object else {
//				fatalError()
//			}
//			instanceMethod(object)(n)
//		}
//		registerObserver(ObjectIdentifier(object), observer: callback)
//
////		_register(self, object, instanceMethod)
//	}
//	public static func deregister<T: AnyObject>(object: T) {
//		deregisterObserver(ObjectIdentifier(object))
//	}
//}
//
//internal func searchBroadcastingStation<T: NotificationType>(_: T.Type) -> MulticastStation<T>? {
////	let	typeID		=	ObjectIdentifier(T)
////	let	ms		=	_mappins[typeID] as! MulticastStation<T>?
////	return	ms
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
////private func _cast<N: NotificationType>(instance: N) {
////	let	typeID	=	ObjectIdentifier(N)
////	if let mc = _mappins[typeID] {
////		let	mc1	=	mc as! MulticastStation<N>
////		mc1.cast(instance)
////	}
////}
////
////private func _register<N: NotificationType, T: AnyObject>(type: N.Type, _ object: T, _ instanceMethod: T -> N -> ()) {
////
//////	let	typeID	=	ObjectIdentifier(type)
//////	if _mappins[typeID] == nil {
//////		_mappins[typeID]	=	MulticastStation<N>()
//////	}
//////	let	mc	=	_mappins[typeID]! as! MulticastStation<N>
//////	mc.register(object, instanceMethod)
////}
////private func _deregister<N: NotificationType, T: AnyObject>(type: N.Type, _ object: T) {
////	N.deregisterObserver(ObjectIdentifier(object))
//////	let	typeID	=	ObjectIdentifier(type)
//////	let	mc	=	_mappins[typeID]! as! MulticastStation<N>
//////	mc.deregister(object)
//////	if mc.observerCount == 0 {
//////		_mappins[typeID]	=	nil
//////	}
////}
////
////
////
//////private var	_mappins	=	[ObjectIdentifier: AnyObject]()		//	Value type is `MulticastStation<T>`.
////
////
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
