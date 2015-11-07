//
//  ReferentialIdentity.swift
//  EditorCommon
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

public func identityOf<T: AnyObject>(o: T) -> ReferentialIdentity<T> {
	return	ReferentialIdentity(o)
}





public func == <T: AnyObject>(a: ReferentialIdentity<T>, b: ReferentialIdentity<T>) -> Bool {
	return	a._id == b._id
}
public struct ReferentialIdentity<T: AnyObject>: Hashable {
	public var hashValue: Int {
		get {
			return	_id.hashValue
		}
	}

	private init(_ object: T) {
		_id	=	ObjectIdentifier(object)
	}
	private let	_id	:	ObjectIdentifier
}