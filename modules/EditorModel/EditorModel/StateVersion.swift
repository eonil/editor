//
//  StateVersion.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/11/05.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public struct StateVersion {
//	func continuation() -> StateVersion {
//		return	StateVersion()
//	}

	mutating func revise() {
		self	=	StateVersion()
	}

	private class _Marker {
	}

	private let _marker	=	_Marker()
}

public func == (a: StateVersion, b: StateVersion) -> Bool {
	return	a._marker === b._marker
}
public func != (a: StateVersion, b: StateVersion) -> Bool {
	return	a._marker !== b._marker

}