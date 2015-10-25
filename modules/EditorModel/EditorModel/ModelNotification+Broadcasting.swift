//
//  ModelNotification+SubcategoryBroadcasting.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/24.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation










/// Defines subcategory notification type.
///
/// You cannot broadcast subcateogory notification directly.
/// But you can observe for them if one of them are notified using `ModelNotification.broadcast`.
/// The notification will be arrived **before** observer registered to `ModelNotification`.
///
public protocol NotificationType {
	static func registerObserver<T: NotificationObserver where T.Notification == Self>(observer: T)
	static func deregisterObserver<T: NotificationObserver where T.Notification == Self>(observer: T)
}
public protocol NotificationObserver: class {
	typealias	Notification: NotificationType
	func processNotification(notification: Notification)
}

public extension NotificationType {
	public func broadcast(doNotCallBroadcast2: Bool = false) {
		if let box = _listMapping[Self._getTypeID()] {
			let	listBox	=	box as! _ListBox<Self>
			for atom in listBox.list {
				let	observer	=	atom.dispatch as! (Self->())
				observer(self)
			}
		}

		if doNotCallBroadcast2 == false {
			broadcast2()
		}
	}
	public static func registerObserver<T: NotificationObserver where T.Notification == Self>(observer: T) {
		let	typeID	=	ObjectIdentifier(self)
		var	box	=	_listMapping[typeID]
		if box == nil {
			box			=	_ListBox<T.Notification>()
			_listMapping[typeID]	=	box
		}
		let	listBox	=	box! as! _ListBox<T.Notification>
		listBox.register(observer)
	}
	public static func deregisterObserver<T: NotificationObserver where T.Notification == Self>(observer: T) {
		let	typeID	=	ObjectIdentifier(Self)
		let	box	=	_listMapping[typeID]

		assert(box != nil)
		let	listBox	=	box! as! _ListBox<T.Notification>
		listBox.deregister(observer)

		if listBox.list.count == 0 {
			_listMapping[typeID]	=	nil
		}
	}
	public static func registerObserver(identifier: ObjectIdentifier, observer: Self->()) {
		typealias	T	=	Self
		let	typeID	=	ObjectIdentifier(self)
		var	box	=	_listMapping[typeID]
		if box == nil {
			box			=	_ListBox<T>()
			_listMapping[typeID]	=	box
		}
		let	listBox	=	box! as! _ListBox<Self>
		listBox.register(identifier, observer: observer)
	}
	public static func deregisterObserver(identifier: ObjectIdentifier) {
		typealias	T	=	Self
		let	typeID	=	ObjectIdentifier(Self)
		let	box	=	_listMapping[typeID]

		assert(box != nil)
		let	listBox	=	box! as! _ListBox<T>
		listBox.deregister(identifier)

		if listBox.list.count == 0 {
			_listMapping[typeID]	=	nil
		}
	}

	///

	static private func _getTypeID() -> ObjectIdentifier {
		return	ObjectIdentifier(self)
	}
}
























private var	_listMapping	=	[ObjectIdentifier: AnyObject]()		// Value is actually `_ListBox` type, but the type has been erased to avoid generic parameter resolution.

private final class _ListBox<N: NotificationType> {
	var	list	=	Array<_ObserverAtom>()

	func register<T: NotificationObserver where T.Notification == N>(observer: T) {
		let	dispatch	=	{ [weak observer] (n: N)->() in
			precondition(observer != nil)
			print(n)
			observer!.processNotification(n)
		}
		register(ObjectIdentifier(observer), observer: dispatch)
	}
	func register(identity: ObjectIdentifier, observer: N->()) {
		list.append((identity, observer))
	}
	func deregister<T: NotificationObserver where T.Notification == N>(observer: T) {
		deregister(ObjectIdentifier(observer))
	}
	func deregister(identity: ObjectIdentifier) {
		let	range	=	list.startIndex..<list.endIndex
		for i in range.reverse() {
			if list[i].id == identity {
				list.removeAtIndex(i)
				return
			}
		}
		fatalError()
	}
}

private typealias _ObserverAtom = (id: ObjectIdentifier, dispatch: Any)	// 2nd parameter is actually `N->() where N: NotificationType`.





