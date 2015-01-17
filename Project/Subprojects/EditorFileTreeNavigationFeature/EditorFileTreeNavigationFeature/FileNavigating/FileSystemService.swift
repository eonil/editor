//
//  FileSystemService.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


extension FileNode4 {
	
	var displayName:String {
		get {
			return	NSFileManager.defaultManager().displayNameAtPath(link.path!)
		}
	}
	
	var existing:Bool {
		get {
			return	NSFileManager.defaultManager().fileExistsAtPath(link.path!)
		}
	}
	
	var directory:Bool {
		get {
			var	f1	=	false as ObjCBool
			return	NSFileManager.defaultManager().fileExistsAtPath(link.path!, isDirectory: &f1) && f1.boolValue
		}
	}
	
	
//	///	Synchronise subnodes with the file system.
//	///	This will try to reuse existing subnodes as many as possible.
//	///	(keeps existing one unless it has been deleted)
//	///	This behavior is by design for NSOutlineView's UX.
//	func reloadSubnodes() {
//		subnodes.links	=	subnodeAbsoluteURLsOfURL(link)
//	}
	
	///	Removes all cached subnodes.
	///	It will remain as empty until you order `reloadSubnodes` explicitly.
	func resetSubnodes() {
		subnodes.links	=	[]
	}
}



















