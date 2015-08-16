////
////  ToolLocationResolver.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/16.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//struct ToolLocationResolver {
//	static func cargoToolLocation() -> String {
//		let	data		=	NSMutableData()
//		let	out		=	NSPipe()
//		out.fileHandleForReading.readabilityHandler	=	{ fileHandle in
//			data.appendData(fileHandle.availableData)
//		}
//
//		let	t		=	NSTask()
//		t.currentDirectoryPath	=	("~" as NSString).stringByExpandingTildeInPath
//		t.standardOutput	=	out
//		t.launchPath		=	"/bin/bash"
//		t.arguments		=	["-c", "/usr/bin/which cargo"]
//		t.launch()
//		t.waitUntilExit()
////		assert(t.terminationStatus == 0)
//		assert(t.terminationReason == .Exit)
//
//		let	str		=	NSString(data: data, encoding: NSUTF8StringEncoding)!
//		return	str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//	}
//}