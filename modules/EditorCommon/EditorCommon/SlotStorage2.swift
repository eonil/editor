////
////  SlotStorage.swift
////  EditorCommon
////
////  Created by Hoon H. on 2015/10/25.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//public class MutableValueStorage2<T>: ValueStorage2<T> {
//	public override init(_ value: T) {
//		super.init(value)
//	}
//
//	public override var value: T {
//		willSet {
//		}
//		didSet {
//		}
//	}
//}
//public class ValueStorage2<T> {
//	private init(_ value: T) {
//		Debug.assertMainThread()
//		_value					=	value
//		_onDidBeginValue.onDidRegister		=	{ [weak self] in $0(self!.value) }
//		_onWillEndValue.onWillDeregister	=	{ [weak self] in $0(self!.value) }
//	}
//	deinit {
//		Debug.assertMainThread()
//	}
//
//	///
//
//	public private(set) var value: T {
//		get {
//			Debug.assertMainThread()
//			return	_value
//		}
//		set {
//			Debug.assertMainThread()
//			assert(_isMutating == false)
//			_isMutating	=	true
//			do {
//				_onWillEndValue.cast(value)
//				_value	=	newValue
//				_onDidBeginValue.cast(value)
//			}
//			_isMutating	=	false
//		}
//	}
//	public var onDidBeginValue: MulticastChannel<T> {
//		get {
//			Debug.assertMainThread()
//			return	_onDidBeginValue
//		}
//	}
//	public var onWillEndValue: MulticastChannel<T> {
//		get {
//			Debug.assertMainThread()
//			return	_onDidBeginValue
//		}
//	}
//
//	///
//
//	private var	_value			:	T
//	private var	_isMutating		=	false
//	private let	_onDidBeginValue	=	MulticastStation<T>()
//	private let	_onWillEndValue		=	MulticastStation<T>()
//}
//
//
////class AAA {
////	func aaa(i: Int) {
////		let	m	=	MulticastChannel<Int>()
////		m.register(self, AAA.aaa)
////	}
////}
//
//



















public class MulticastStation<Parameter>: MulticastChannel<Parameter> {
	public override init() {
	}
	public func cast(parameter: Parameter) {
		_cast(parameter)
	}
	public var onDidRegister: ((Callback)->())? {
		get {
			return	_onDidRegister
		}
		set {
			_onDidRegister	=	newValue
		}
	}
	public var onWillDeregister: ((Callback)->())? {
		get {
			return	_onWillDeregister
		}
		set {
			_onWillDeregister	=	newValue
		}
	}
}

/// http://blog.scottlogic.com/2015/02/05/swift-events.html
public class MulticastChannel<Parameter> {
	public typealias	Callback	=	(Parameter)->()

	private init() {
	}
	deinit {
		assert(_list.count == 0, "You MUST deregister all observers before this object `\(self)` dies.")
	}

	///

	public var numberOfObservers: Int {
		get {
			return	_list.count
		}
	}
	public func register<T: AnyObject>(object: T, _ instanceMethod: (T) -> Callback) {
		let	invoke	=	{ [weak object] (parameter: Parameter)->() in
			guard let object = object else {
				fatalError()
			}
			instanceMethod(object)(parameter)
		}
		register(ObjectIdentifier(object), invoke)
	}
	public func deregister<T: AnyObject>(object: T) {
		deregister(ObjectIdentifier(object))
	}

	///

	public func register(identifier: ObjectIdentifier, _ function: Callback) {
		let	atom	=	(identifier, function)
		_list.append(atom)
		_onDidRegister?(atom.1)
	}
	public func deregister(identifier: ObjectIdentifier) {
		let	range	=	_list.startIndex..<_list.endIndex
		for i in range.reverse() {
			let	atom	=	_list[i]
			if atom.0 == identifier {
				_onWillDeregister?(atom.1)
				_list.removeAtIndex(i)
				return
			}
		}
		fatalError()
	}

	///

	private typealias	_Atom			=	(identity: ObjectIdentifier, invoke: Callback)

	private var		_list			=	[_Atom]()

	private var		_onDidRegister		:	((Callback)->())?
	private var		_onWillDeregister	:	((Callback)->())?

	private func _cast(parameter: Parameter) {
		for atom in _list {
			atom.invoke(parameter)
		}
	}
}










