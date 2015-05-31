//
//  System.swift
//  Monolith
//
//  Created by Hoon H. on 10/18/14.
//
//

import Foundation


struct System {
	
	@noreturn static func crashByProgramBugWithMessage() {
		println("CRASH by program bug.")
		System.Debug.pause()
		abort()
	}
	
	struct Debug {
		static func log(object:Any) {
			println(object)
		}
		
		@noreturn static func unreachable() {
			System.crashByProgramBugWithMessage()
		}
		
		///	Brings debugger on request.
		static func pause() {
			assert(false, "Brings a DEBUGGER by programmer request.")
		}
	}
	
}


