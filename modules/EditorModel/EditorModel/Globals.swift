//
//  Globals.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/25.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper

public func initializeModelModule() {
	LLDBGlobals.initializeLLDBWrapper()
}

public func terminateModelModule() {
	LLDBGlobals.terminateLLDBWrapper()
}





