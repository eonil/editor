//
//  FileLocation.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

struct FileLocation {
	let	stringExpression:NSURL
	let	fileSystemNode:NSURL
	
	init(_ u:NSURL) {
		assert(u.isFileReferenceURL() == false)
		assert(u.fileURL)
		
		self.stringExpression	=	u
		self.fileSystemNode		=	u.fileReferenceURL()!
	}
}

extension FileLocation: Printable {
	var description:String {
		get {
			return	[stringExpression, fileSystemNode].description
		}
	}
}