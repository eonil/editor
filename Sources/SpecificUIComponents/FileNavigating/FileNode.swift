//
//  FileNode.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


final class FileNode {
	let			relativePath:String
	let			supernode:FileNode?
	
	private var _subnodes:[FileNode]?
	
	///	Makes a root node.
	init(path:String) {
		self.relativePath	=	path
	}
	init(supernode:FileNode, relativePath:String) {
		self.supernode		=	supernode
		self.relativePath	=	relativePath
	}
	var absoluteURL:NSURL {
		get {
			return	NSURL(fileURLWithPath: absolutePath)!
		}
	}
	var	absolutePath:String {
		get {
			return	supernode == nil ? relativePath : supernode!.absolutePath.stringByAppendingPathComponent(relativePath)
		}
	}
	var	existing:Bool {
		get {
			return	NSFileManager.defaultManager().fileExistsAtPath(absolutePath)
		}
	}
	
	var	data:NSData? {
		get {
			if NSFileManager.defaultManager().fileExistsAtPathAsDataFile(absolutePath) {
				return	NSData(contentsOfFile: absolutePath)
			}
			return	nil
		}
	}
	var subnodes:[FileNode]? {
		get {
			
			if NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(absolutePath) {
				if _subnodes == nil {
					_subnodes	=	[]
					let	u1	=	absoluteURL
					let	e1	=	NSFileManager.defaultManager().enumeratorAtURL(u1, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles | NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, errorHandler: { (url:NSURL!, error:NSError!) -> Bool in
						return	false
					})
					let	e2	=	e1!
					while let o1 = e2.nextObject() as? NSURL {
						let	p2	=	o1.path!.lastPathComponent
						let	n1	=	FileNode(supernode: self, relativePath: p2)
						_subnodes!.append(n1)
					}
				}
				return	_subnodes!
			}
			return	nil
			
//			if NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(absolutePath) {
//				if _subnodes == nil {
//					_subnodes	=	[]
//					let	e1	=	NSFileManager.defaultManager().enumeratorAtPath(absolutePath)!
//					e1.skipDescendants()
//					while let o1 = e1.nextObject() as? String {
//						let	n1	=	FileNode(path: o1)
//						_subnodes!.append(n1)
//					}
//				}
//				return	_subnodes!
//			}
//			return	nil
		}
	}
}

extension FileNode {
	
	var	displayName:String {
		get {
			return	NSFileManager.defaultManager().displayNameAtPath(absolutePath)
		}
	}
}






