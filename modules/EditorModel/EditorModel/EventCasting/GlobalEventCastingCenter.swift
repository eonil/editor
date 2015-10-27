////
////  GlobalEventCastingCenter.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/10/26.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import EditorCommon
////
////internal struct GlobalEventCastingCenter<Sender: AnyObject where Sender: ModelType, Sender.Event: EventType, Sender.Event.Sender == Sender> {
////	static func multicast(sender: Sender, event: Sender.Event) {
////		@noreturn
////		func onError() -> AnyObject {
////			fatalError("Cannot find a multicast object for the sender `\(sender)`.")
////		}
////
////		let	senderID	=	ObjectIdentifier(sender)
////		let	senderMulticast	=	_senderInstanceToMulticastMapping._valueForKey(senderID, withDefaultValueGenerator: onError) as! EditorCommon.MulticastStation<Sender.Event>
////		senderMulticast.cast(event)
////
////	}
////	static func register<Receiver: AnyObject>(sender: Sender, _ receiver: Receiver, _ function: Receiver -> Sender.Event -> ()) {
////		let	senderID	=	ObjectIdentifier(sender)
////		let	senderMulticast	=	_senderInstanceToMulticastMapping._valueForKey(senderID) { EditorCommon.MulticastStation<Sender.Event>() } as! EditorCommon.MulticastStation<Sender.Event>
////		senderMulticast.register(receiver, function)
////	}
////	static func deregister<Receiver: AnyObject>(sender: Sender, _ receiver: Receiver) {
////		@noreturn
////		func onError() -> AnyObject {
////			fatalError("Cannot find a multicast object for the sender `\(sender)`.")
////		}
////
////		let	senderID	=	ObjectIdentifier(sender)
////		let	senderMulticast	=	_senderInstanceToMulticastMapping._valueForKey(senderID, withDefaultValueGenerator: onError) as! EditorCommon.MulticastStation<Sender.Event>
////		senderMulticast.deregister(receiver)
////		if senderMulticast.observerCount == 0 {
////			_senderInstanceToMulticastMapping[senderID]	=	nil
////		}
////	}
////	private init() {
////	}
////}
////
////
////
////
/////// Key is ObjectIdentifier for a sender instance.
/////// Value is MulticastStation<T> where T is appropriate type.
////private var	_senderInstanceToMulticastMapping	=	[ObjectIdentifier: AnyObject]()
////
////private var	_senderTypeToMulticastMapping		=	[ObjectIdentifier: AnyObject]()
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////private extension Dictionary {
////	mutating func _valueForKey(key: Key, withDefaultValueGenerator g: ()->Value) -> Value {
////		guard let v = self[key] else {
////			let	v1	=	g()
////			self[key]	=	v1
////			return	v1
////		}
////		return	v
////	}
////}
////
////
////
////
////
////
