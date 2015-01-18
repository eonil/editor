//
//  IconUtility.swift
//  EditorIssueListingFeature
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

struct IconUtility {
	static func iconForURL(u:NSURL) -> NSImage {
		return	iconForPath(u.path!)
	}
	static func iconForPath(s:String) -> NSImage {
		return	NSWorkspace.sharedWorkspace().iconForFile(s)
	}
	static func unknownFileIcon() -> NSImage {
		return	iconForCodeUsingIconServices(kUnknownFSObjectIcon)
	}
	
	///	The code is something like `kComputerIcon`.
	///	Command+Clock the `kComputerIcon` identifier to see more constants.
	static func iconForCodeUsingIconServices(code:Int) -> NSImage {
		let	n	=	OSType(UInt32(bitPattern: Int32(code)))
		return	iconForOSType(n)
	}
	static func iconForOSType(c:OSType) -> NSImage {
		let	n1	=	NSFileTypeForHFSTypeCode(c)
		let	m	=	NSWorkspace.sharedWorkspace().iconForFileType(n1)
		return	m
	}
}

