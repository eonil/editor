//
//  Test.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 11/9/14.
//
//

import Foundation


struct Test {
	static var mode:Bool {
		get {
			#if	TEST
				return	true
			#else
				return	false
			#endif
		}
	}
	
}