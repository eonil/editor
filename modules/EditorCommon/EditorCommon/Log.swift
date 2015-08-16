//
//  Log.swift
//  EditorCommon
//
//  Created by Hoon H. on 2015/08/16.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public struct Debug {
	public static func log<T>(value: T) {
		//	TODO:	Disable in debug build.
		print("LOG: \(value)")
	}
}