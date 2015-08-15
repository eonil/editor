//
//  Reporting.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public func assertAndReportFailure(@autoclosure condition: ()->Bool, _ message: String) {
	assert(condition(), message)
}

public func fatalErrorBecauseUnimplementedYet() {
	fatalError("Unimplemented yet!")
}

///	Marks unimplemented points, but has been ignored for faster implementation.
public func markUnimplemented(@autoclosure message: ()->String = "", file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
	print("WARN: UNIMPLEMENTED: message = \(message()), file = \(file), line = \(line), function = \(function)")
//	fatalErrorBecauseUnimplementedYet()
}