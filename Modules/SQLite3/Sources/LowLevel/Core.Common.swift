//
//  Core.Common.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/15/14.
//
//

import Foundation

extension Core {
	struct Common {
	}
}

extension Core.Common {
	@noreturn static func crash(message s:String = "") {
		fatalError("CRASH requested by PROGRAMMER for core C inter-ops" + (s == "" ? "." : (": " + s)))
	}
	
	
	
	struct C {
		
		static let	NULL		=	nil as COpaquePointer
		
		static let	TRUE		=	Int32(1)
		static let	FALSE		=	Int32(0)
		
	}
}