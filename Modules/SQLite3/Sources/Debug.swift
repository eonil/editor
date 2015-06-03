//
//  Debug.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/17/14.
//
//

import Foundation




struct Debug {
	static var mode:Bool {
		get {
			#if	DEBUG
				return	true
			#else
				return	false
			#endif
		}
	}
	
	static let	useCoreLogging	=	false
	
	static func log<T>(@autoclosure object:()->T) {
		if Debug.mode && Test.mode {
			println(object())
		}
	}
	
	
}











///	Crashes the app only in debug mode.
@noreturn func crash(_ message:String = "Reason unknown.") {
	fatalError("Crash requested by programmer: " + message)
}



///	Install these traps to make a conditional breakpoint for specific situations.
@noreturn func trapConvenientExtensionsError(message:String) {
	crash(message)
}
@noreturn func trapError(message:String) {
	crash(message)
}
