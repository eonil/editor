//
//  EventType.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/26.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public protocol EventType {
	typealias	Sender
//	static func registerObserver<T: NotificationObserver where T.Notification == EditorModel.Notification<Sender,Self>>(observer: T)
//	static func deregisterObserver<T: NotificationObserver where T.Notification == EditorModel.Notification<Sender,Self>>(observer: T)
//
////	static func registerObserver(identity: ObjectIdentifier, observer: EditorModel.Notification<Sender,Self>->())
////	static func deregisterObserver(identity: ObjectIdentifier)
//
////	static func register<T: AnyObject>(identity: T, observer: Notification->())
////	static func deregister<T: AnyObject>(identity: T)
//
//	static func register<T: AnyObject>(identity: T, _ instanceMethod: T -> Notification -> ())
//	static func deregister<T: AnyObject>(identity: T)
}
public extension EventType {
	public typealias	Notification		=	EditorModel.Notification<Sender,Self>
//	public static func registerObserver<T: NotificationObserver where T.Notification == Notification>(observer: T) {
//		Notification.registerObserver(observer)
//	}
//	public static func deregisterObserver<T: NotificationObserver where T.Notification == Notification>(observer: T) {
//		Notification.deregisterObserver(observer)
//	}
//
////	public static func registerObserverWithIdentity(identity: ObjectIdentifier, observer: Notification->()) {
////		Notification.registerObserver(identity, observer: observer)
////	}
////	public static func deregisterObserverWithIdentity(identity: ObjectIdentifier) {
////		Notification.deregisterObserver(identity)
////	}
//
////	public static func register<T: AnyObject>(identity: T, observer: Notification->()) {
////		Notification.registerObserver(ObjectIdentifier(identity), observer: observer)
////	}
////	public static func deregister<T: AnyObject>(identity: T) {
////		Notification.deregisterObserver(ObjectIdentifier(identity))
////	}
//
//	public static func register<T: AnyObject>(object: T, _ instanceMethod: T -> Notification -> ()) {
//		Notification.register(object, instanceMethod)
//	}
//	public static func deregister<T: AnyObject>(object: T) {
//		Notification.deregister(object)
//	}
}





internal protocol BroadcastableEventType: EventType {

}
internal extension BroadcastableEventType {
	internal func broadcastWithSender(sender: Sender) {
		Notification(sender, self).broadcast()
	}
}
















//public enum FileNodeNotification: SubcategoryNotificationType {
//	case DidInsertSubnode(node: FileNodeModel, subnode: FileNodeModel, index: Int)
//	case WillDeleteSubnode(node: FileNodeModel, subnode: FileNodeModel, index: Int)
//	case WillChangeGrouping(node: FileNodeModel, old: Bool, new: Bool)
//	case DidChangeGrouping(node: FileNodeModel, old: Bool, new: Bool)
//	case WillChangeName(node: FileNodeModel, old: String, new: String)
//	case DidChangeName(node: FileNodeModel, old: String, new: String)
//	case WillChangeComment(node: FileNodeModel, old: String?, new: String?)
//	case DidChangeComment(node: FileNodeModel, old: String?, new: String?)
//}



// Delegate is good for single-cast, but not for multi-case because we need to duplicate 
// multicasting for every method.
//
// Multicasting channel is good in many ways, but it requires closure. And that's verbose,
// and annoying. Connecting handler is annoying. Also, single-element tuple cannot have 
// a label, so this is not an option.
//
// Notification is well balanced and simple. Though we need to code every cases with typing 
// proper signatures... it's matter of IDE, so it will be better over time.



