//
//  Reporting.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public func checkAndReportFailureToDevelopers(@autoclosure condition: ()->Bool, _ message: String? = nil) {
	let	conditionEvaluation	=	condition()

	if let message = message {
		assert(conditionEvaluation, message)
	}
	else {
		assert(conditionEvaluation)
	}

	reportToDevelopers(message)

	#if Debug
		if conditionEvaluation == false {
			fatalError()
		}
	#endif
}

public func reportToDevelopers(message: String? = nil) {
	// Not yet implemented.
	// Here will be a code that reports failure to developers.
	// 1. Persist error on disk to secure it.
	// 2. Try to dispatch this to dev server in synchronous manner.
	// 3. Erased persisted error if it's been successfully sent.
	//    Otherwise retry sending at next launch.
}


public func assertAndReportFailure(@autoclosure condition: ()->Bool, _ message: String) {
	assert(condition(), message)
}

public func fatalErrorBecauseUnimplementedYet() {
	fatalError("Unimplemented yet!")
}

/// Marks unimplemented points, but has been ignored for faster implementation.
public func markUnimplemented(@autoclosure message: ()->String = "", file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
	Debug.log("WARN: UNIMPLEMENTED: message = \(message()), file = \(file), line = \(line), function = \(function)")
//	fatalErrorBecauseUnimplementedYet()
}
