//
//  FoundationExtensions.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

public extension NSIndexSet {
	public convenience init(_ indexes:[Int]) {
		let	s1	=	NSMutableIndexSet()
		for idx1 in indexes {
			s1.addIndex(idx1)
		}
		self.init(indexSet: s1)
	}
	public var allIndexes:[Int] {
		var	idxs	=	[] as [Int]
		self.enumerateIndexesUsingBlock { (idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
			idxs.append(idx)
		}
		return	idxs
	}
}

public extension NSString {
	public func findNSRangeOfLineContentAtIndex(lineIndex:Int) -> NSRange? {
		var	counter					=	0
		var	currentCapturingRange	=	NSRange(location: 0, length: self.length)
		let	options					=	NSStringEnumerationOptions.ByLines | NSStringEnumerationOptions.SubstringNotRequired
		var	resultingSubstringRange	=	nil as NSRange?
		self.enumerateSubstringsInRange(currentCapturingRange, options: options) { (substring:String!, substringRange, enclosingRange, stop:UnsafeMutablePointer<ObjCBool>) -> () in
			if counter == lineIndex {
				resultingSubstringRange	=	substringRange
				stop.memory	=	true
			}
			counter++
		}
		return	resultingSubstringRange
	}
}


public extension NSScanner {
	public func scanInt() -> Int? {
		var	v1:Int	=	0
		let	ok1		=	self.scanInteger(&v1)
		return	v1
	}
	public func scanUpToString(s:String) -> String? {
		var	s1:NSString?
		let	ok1		=	self.scanUpToString(s, intoString: &s1)
		return	s1
	}
}

public extension NSFileManager {
	public func fileExistsAtPathAsDataFile(path:String) -> Bool {
		var	flag:ObjCBool	=	false
		let	ok1	=	self.fileExistsAtPath(path, isDirectory: &flag)
		return	ok1 && (flag.boolValue == false)
	}
	public func fileExistsAtPathAsDirectoryFile(path:String) -> Bool {
		var	flag:ObjCBool	=	false
		let	ok1	=	self.fileExistsAtPath(path, isDirectory: &flag)
		return	ok1 && (flag.boolValue == true)
	}
//	public func fileExistsAtPathAsSymbolicLink(path:String) -> Bool {
//	}
}




public extension NSURL {
	public var displayName:String {
		get {
			return	NSFileManager.defaultManager().displayNameAtPath(path!)
		}
	}
//	public var existingAsAnyFile:Bool {
//		get {
//			return	NSFileManager.defaultManager().fileExistsAtPath(self.path!)
//		}
//	}
	public var existingAsDataFile:Bool {
		get {
			assert(self.fileURL)
			return	NSFileManager.defaultManager().fileExistsAtPathAsDataFile(self.path!)
		}
	}
	public var existingAsDirectoryFile:Bool {
		get {
			assert(self.fileURL)
			return	NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(self.path!)
		}
	}
}

























