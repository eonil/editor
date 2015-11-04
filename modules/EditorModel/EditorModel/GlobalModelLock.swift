//
//  GlobalModelLock.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/11/04.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon

class GlobalModelLock {
	static func lockBeforeDispatchingEvent() {
		assert(_isLocked.state == false)
		_isLocked.state	=	true
	}
	static func unlockAfterDispatchingEvent() {
		assert(_isLocked.state == true)
		_isLocked.state	=	false
	}

	private static var	_isLocked	=	AtomicBool(false)
}


/// Executes a mutation with model-global mutaiton lock check.
/// Mutation usually doesn't need return value. If your mutation
/// code needs a return value, usually it's wrongly designed.
func mutateWithGlobalCheck(@noescape code: () -> ()) {
	assert(GlobalModelLock._isLocked.state == false)
	code()
}
func mutateWithGlobalCheck(@noescape code: () throws ->()) throws {
	assert(GlobalModelLock._isLocked.state == false)
	try code()
}