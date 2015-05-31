//
//  Configuration.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 11/2/14.
//
//

import Foundation

struct Configuration {
//	public var	schemaEditable:Bool			///<	Allows user to edit schema.
//	public var	contentEditable:Bool		///<	Allows user to edit contents.
	
//	var	allowCreationIfNotExists	=	true
	
	
//	///	Specifies a name generator which will generate names for `SAVEPOINT`
//	///	statement. Crash the app if you can't generate any more names.
//	///
//	///	The `Database` class uses unique `SAVEPOINT` name generator
//	///	to support nested transaction. If you perform the
//	///	`SAVEPOINT` operation youtself manually, the savepoint
//	///	name may be duplicated and derive unexpected result.
//	///	To precent this situation, supply your own
//	///	implementation of savepoint name generator at
//	///	initializer.
//	var	savepointNameGenerator:()->String
	
	var	sessionwideSavepointName:String	=	"EonilSQLite3_SAVEPOINT_NAME_" + NSUUID().UUIDString
}