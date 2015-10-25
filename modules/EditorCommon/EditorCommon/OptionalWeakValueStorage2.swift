//
//  OptionalWeakValueStorage2.swift
//  EditorCommon
//
//  Created by Hoon H. on 2015/10/25.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public class MutableOptionalWeakObjectStorage2<T: AnyObject>: OptionalWeakObjectStorage2<T> {
	public override init(_ value: T?) {
		super.init(value)
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
	private init(_ value: T?) {
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
			return	_value
		}
		set {
			assert(_valueIsNil == (_value == nil))
			_onWillEndValue.cast(value)
			_value		=	newValue
			_valueIsNil	=	_value == nil
			_onDidBeginValue.cast(value)
		}
	}
	public var onDidBeginValue: MulticastChannel<T?> {
		get {
			return	_onDidBeginValue
		}
	}
	public var onWillEndValue: MulticastChannel<T?> {
		get {
			return	_onDidBeginValue
		}
	}

	///

	private weak var 	_value			:	T?
	private var		_valueIsNil		=	false
	private let		_onDidBeginValue	=	MulticastStation<T?>()
	private let		_onWillEndValue		=	MulticastStation<T?>()
}







