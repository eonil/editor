//
//  Errors.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

@noreturn
func deletedPropertyFatalError() {
	fatalError("Using of this property is prohibited.")
}