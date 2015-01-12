//
//  FileUtility.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

public struct FileUtility {
	public static func createNewFileInFolder(parentFolder:NSURL) {
		
	}
	
	///	Returns URL to the created folder if succeeded.
	///	An error on failure.
	public static func createNewFolderInFolder(parentFolder:NSURL) -> Resolution<NSURL> {
		let u2	=	parentFolder
		let	u	=	u2.existingAsDirectoryFile ? u2 : u2.URLByDeletingLastPathComponent!
		assert(u.existingAsDirectoryFile)
		
		if let nm = generateUniqueNameForNewFolderAtParentDirectoryAtURL(u) {
			assert(u.URLByAppendingPathComponent("\(nm)").existingAsDataFile == false)
			assert(u.URLByAppendingPathComponent("\(nm)/").existingAsDirectoryFile == false)
			
			let	u1	=	u.URLByAppendingPathComponent("\(nm)/")	//	Ending `/` has significant meaning to represent directory, and shouldn't be omitted.
			var	err	=	nil as NSError?
			let	ok	=	NSFileManager.defaultManager().createDirectoryAtURL(u1, withIntermediateDirectories: true, attributes: nil, error: &err)
			if !ok {
				return	Resolution.failure(err!)
			} else {
				return	Resolution.success(u1)
			}
		} else {
			//	No proper name could be made. Sigh...
			let	inf	=	[NSLocalizedDescriptionKey: "There're too many folders named \"New Folder...\". Please erase some before proceeding."]
			let	err	=	NSError(domain: "", code: 0, userInfo: inf)
			return	Resolution.failure(err)
		}
	}
}

