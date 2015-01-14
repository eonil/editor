//
//  File.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/11.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import Precompilation




/////	Generates a user-friendly *name* for a data file.
/////	Returns `nil` if a proper name cannot be made in short time.
//func generateUniqueUserFriendlyNameForNewFileAtParentDirectoryAtURL(u:NSURL) -> String? {
//	return	generateUniqueUserFriendlyNameWithPrefixAtParentDirectoryAtURL(u, prefixString: "New File")
//}
//
//
/////	Generates a user-friendly *name* for a directory file.
/////	Returns `nil` if a proper name cannot be made in short time.
//func generateUniqueUserFriendlyNameForNewFolderAtParentDirectoryAtURL(u:NSURL) -> String? {
//	return	generateUniqueUserFriendlyNameWithPrefixAtParentDirectoryAtURL(u, prefixString: "New Folder")
//}



///	Generates a user-friendly *name* for a new file.
///	Returns `nil` if a proper name cannot be made in short time.
func generateUniqueUserFriendlyNameWithPrefixAtParentDirectoryAtURL(u:NSURL, prefixString n:String) -> String? {
	func isNameExists(base:NSURL, n:String) -> Bool {
		let	u	=	base.URLByAppendingPathComponent(n)		//	This will add ending slash if a directory at the path exists.
		return	u.existingAsDataFile || u.existingAsDirectoryFile
	}
	
	if isNameExists(u, n) == false {
		return	n
	}
	
	let	MAX_TRIAL_COUNT	=	256
	for i in 1..<MAX_TRIAL_COUNT {
		let	n1	=	n + " \(i)"
		if isNameExists(u, n1) == false {
			return	n1
		}
	}
	
	return	nil
}









