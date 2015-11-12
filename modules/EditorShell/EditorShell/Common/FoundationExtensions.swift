//
//  FoundationExtensions.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/10/25.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

extension NSNotificationCenter {
	/// Only for main thread.
	func addUIObserver<T: AnyObject>(instance: T, _ instanceMethod: T -> (NSNotification) -> (), _ notificationName: String) {
		assert(NSThread.isMainThread())
		addUIObserver(ObjectIdentifier(instance), forNotificationName: notificationName) { [weak instance](n: NSNotification) -> () in
			assert(instance != nil)
			instanceMethod(instance!)(n)
		}
	}
	/// Only for main thread.
	func removeUIObserver<T: AnyObject>(instance: T, _ notificationName: String) {
		assert(NSThread.isMainThread())
		removeUIObserver(ObjectIdentifier(instance), forNotificationName: notificationName)
	}
	


	/// Only for main thread.
	func addUIObserver(identifier: ObjectIdentifier, forNotificationName name: String, handler: (NSNotification)->()) {
		assert(NSThread.isMainThread())

		let	contract		=	_Contract(identity: identifier, name: name)
		let	observationContext	=
		NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: NSOperationQueue.mainQueue()) { (n: NSNotification) -> Void in
			guard _observerContractMap[contract] != nil else {
				return
			}
			handler(n)
		}

		_observerContractMap[contract]	=	observationContext
	}
	/// Only for main thread.
	func removeUIObserver(identifier: ObjectIdentifier, forNotificationName name: String) {
		assert(NSThread.isMainThread())

		let	contract		=	_Contract(identity: identifier, name: name)
		guard let observationContext = _observerContractMap[contract] else {
			fatalError("The observer hasn't registered to this notification center.")
		}
		NSNotificationCenter.defaultCenter().removeObserver(observationContext, name: name, object: nil)
		_observerContractMap[contract]	=	nil
	}
}


private var	_observerContractMap	=	[_Contract: AnyObject]()

private struct _Contract: Hashable {
	var	identity: ObjectIdentifier
	var	name: String

	var hashValue: Int {
		get {
			return	identity.hashValue | name.hashValue
		}
	}
}
private func ==(a: _Contract, b: _Contract) -> Bool {
	return	a.identity == b.identity && a.name == b.name
}