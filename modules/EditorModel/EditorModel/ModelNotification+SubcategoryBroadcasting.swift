//
//  ModelNotification+SubcategoryBroadcasting.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/24.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation



public protocol SubcategoryNotificationType {
}
public protocol SubcategoryNotificationObserver: class {
	typealias	Notification: SubcategoryNotificationType
	func processNotification(_: Notification)
}
public extension SubcategoryNotificationType {
	public func broadcast() {
		if let box = _listMapping[Self._getTypeID()] {
			let	listBox	=	box as! _ListBox<Self>
			for atom in listBox.list {
				let	observer	=	atom.dispatch as! (Self->())
				observer(self)
			}
		}
	}
	public static func registerObserver<T: SubcategoryNotificationObserver where T.Notification == Self>(observer: T) {
		let	typeID	=	ObjectIdentifier(self)
		var	box	=	_listMapping[typeID]
		if box == nil {
			box			=	_ListBox<T.Notification>()
			_listMapping[typeID]	=	box
		}
		let	listBox	=	box! as! _ListBox<T.Notification>
		listBox.register(observer)
	}
	public static func deregisterObserver<T: SubcategoryNotificationObserver where T.Notification == Self>(observer: T) {
		let	typeID	=	ObjectIdentifier(Self)
		let	box	=	_listMapping[typeID]

		assert(box != nil)
		let	listBox	=	box! as! _ListBox<T.Notification>
		listBox.deregister(observer)

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

private final class _ListBox<N: SubcategoryNotificationType> {
	var	list	=	Array<_ObserverAtom>()

	func register<T: SubcategoryNotificationObserver where T.Notification == N>(observer: T) {
		let	dispatch	=	{ [weak observer] (n: N)->() in
			precondition(observer != nil)
			observer!.processNotification(n)
		}
		list.append((ObjectIdentifier(observer), dispatch))
	}
	func deregister<T: SubcategoryNotificationObserver where T.Notification == N>(observer: T) {
		let	range	=	list.startIndex..<list.endIndex
		for i in range.reverse() {
			if list[i].id == ObjectIdentifier(observer) {
				list.removeAtIndex(i)
				return
			}
		}
		fatalError()
	}
}

private typealias _ObserverAtom = (id: ObjectIdentifier, dispatch: Any)	// 2nd parameter is actually `N->() where N: SubcategoryNotificationType`.





