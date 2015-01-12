//
//  File.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/11.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation







///	Generates a *name* for a new folder.
///	Returns `nil` if a proper name cannot be made in short time.
func generateUniqueNameForNewFolderAtParentDirectoryAtURL(u:NSURL) -> String? {
	func isNameExists(base:NSURL, n:String) -> Bool {
		let	u	=	base.URLByAppendingPathComponent(n)		//	This will add ending slash if a directory at the path exists.
		return	u.existingAsDataFile || u.existingAsDirectoryFile
	}
	
	let	n	=	"New Folder"
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