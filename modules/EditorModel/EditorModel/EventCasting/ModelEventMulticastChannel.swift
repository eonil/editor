////
////  ModelEventMulticastChannel.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/10/26.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import EditorCommon
//
//public struct ModelEventMulticastChannel<Sender: AnyObject where Sender: ModelType, Sender.Event: EventType, Sender.Event.Sender == Sender> {
//	typealias	Parameter	=	Sender.Event
//
//	private let sender: Sender
//
//	internal init(sender: Sender) {
//		self.sender	=	sender
//	}
//	internal func cast(event: Sender.Event) {
//		GlobalEventCastingCenter<Sender>.multicast(sender, event: event)
//	}
//
//	public func register<Receiver : AnyObject>(object: Receiver, _ instanceMethod: Receiver -> Parameter -> ()) {
//		GlobalEventCastingCenter<Sender>.register(sender, object, instanceMethod)
//	}
//	public func deregister<Receiver : AnyObject>(object: Receiver) {
//		GlobalEventCastingCenter<Sender>.deregister(sender, object)
//	}
//}
//
//public extension ModelType where Self.Event: EventType, Self == Self.Event.Sender {
//	public var event: ModelEventMulticastChannel<Self> {
//		get {
//			return	ModelEventMulticastChannel(sender: self)
//		}
//	}
//}
