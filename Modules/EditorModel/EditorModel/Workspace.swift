//
//  Workspace.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/05/31.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph

public class Workspace {
	
	public init(rootDirectoryURL: NSURL) {
		self.rootDirectoryURL	=	ValueChannel<NSURL>(rootDirectoryURL)
		
		editing.owner	=	self
		toolbox.owner	=	self
		debugger.owner	=	self
		console.owner	=	self
	}
	
	public let	rootDirectoryURL	:	ValueChannel<NSURL>
	
//	public let	package		=	
	public let	editing		=	Editing()
	public let	toolbox		=	Toolbox()
	public let	debugger	=	Debugger()
	public let	console		=	Console()
	
//	public init(rootURL: NSURL) {
//		func TEMP_ADHOC_getTargetName() -> String? {
//			let	p1	=	rootPath.stringByAppendingPathComponent("Cargo.toml")
//			let	d1	=	NSData(contentsOfFile: p1)!
//			let	s1	=	NSString(data: d1, encoding: NSUTF8StringEncoding)! as String
//			let	lines1	=	split(s1, maxSplit: Int.max, allowEmptySlices: false, isSeparator: { $0 == "\n" })
//			let	lines2	=	lines1.map({ $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) })
//			let	lines3	=	lines2.filter({ $0 != "" && $0.hasPrefix("name") })
//			let	line4	=	lines3.first ?? ""
//			let	parts5	=	split(line4, maxSplit: 2, allowEmptySlices: true, isSeparator: { $0 == "=" })
//			let	name6	=	parts5.count >= 2 ? parts5[1] : nil as String?
//			return	name6
//		}
//		
//		let	n	=	queryCargoAtDirectoryURL(rootURL, "package.name")
//		_target.state	=	n == nil ? nil : Target(name: n!)
//	}
//	public var target: ValueStorage<Target?> {
//		get {
//			return	_target
//		}
//	}
//	
//	///	MARK:	-
//	
//	private let	_target		=	EditableValueStorage<Target?>(nil);
}

//public struct Target {
//	public var	name		:	String
//}


