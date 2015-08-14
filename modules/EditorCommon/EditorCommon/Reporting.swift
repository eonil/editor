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