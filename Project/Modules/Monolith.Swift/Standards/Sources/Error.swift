//
//  Error.swift
//  Monolith
//
//  Created by Hoon H. on 10/21/14.
//
//

import Foundation

struct Error {
	static func trap(_ message:String? = nil) -> () {
		///	Install debugger breakpoint here to stop at any returning-by-an-error situation.
		#if DEBUG
			if message != nil {
			println("Trapped an error: " + message!)
			}
		#endif
	}
	
	static func trap<T>(_ message:String? = nil) -> T? {
		///	Install debugger breakpoint here to stop at any returning-`nil`-by-an-error situation.
		trap(message)
		return	nil
	}
}

