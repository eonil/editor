//
//  OptionalWeakValueStorage2.swift
//  EditorCommon
//
//  Created by Hoon H. on 2015/10/25.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public class MutableOptionalWeakObjectStorage2<T: AnyObject>: OptionalWeakObjectStorage2<T> {
	public override init(_ value: T?, skipCastingForIdenticalObjects: Bool = false){
		super.init(value, skipCastingForIdenticalObjects: skipCastingForIdenticalObjects)

	}

	public override var value: T? {
		get {
			return	super.value
		}
		set {
			super.value	=	value
		}
	}
}

/// This stores weak reference, but it doesn't mean you can kill the value
/// while it is being bound to this storage. You're responsible to keep it
/// alive while it is being used in this storage. Remove the value explicitly
/// from this storage if you set it to `nil`.
public class OptionalWeakObjectStorage2<T: AnyObject> {
	private init(_ value: T?, skipCastingForIdenticalObjects: Bool) {
		Debug.assertMainThread()
		_skipIdenticals				=	skipCastingForIdenticalObjects
		_value					=	value
		_valueIsNil				=	value == nil
		_onDidBeginValue.onDidRegister		=	{ [weak self] in $0(self!.value) }
		_onWillEndValue.onWillDeregister	=	{ [weak self] in $0(self!.value) }
	}
	deinit {
	}

	///

	public private(set) var value: T? {
		get {
			Debug.assertMainThread()
			return	_value
		}
		set {
			Debug.assertMainThread()
			guard _skipIdenticals == false || _value !== newValue else {
				return
			}

			assert(_valueIsNil == (_value == nil))
			assert(_isMutating == false)
			_isMutating	=	true
			do {
				_onWillEndValue.cast(value)
				_value		=	newValue
				_valueIsNil	=	_value == nil
				_onDidBeginValue.cast(value)
			}
			_isMutating	=	false
		}
	}
	public var onDidBeginValue: MulticastChannel<T?> {
		get {
			Debug.assertMainThread()
			return	_onDidBeginValue
		}
	}
	public var onWillEndValue: MulticastChannel<T?> {
		get {
			Debug.assertMainThread()
			return	_onDidBeginValue
		}
	}

	///

	private let		_skipIdenticals		:	Bool
	private weak var 	_value			:	T?
	private var		_valueIsNil		=	false
	private var		_isMutating		=	false
	private let		_onDidBeginValue	=	MulticastStation<T?>()
	private let		_onWillEndValue		=	MulticastStation<T?>()
}







