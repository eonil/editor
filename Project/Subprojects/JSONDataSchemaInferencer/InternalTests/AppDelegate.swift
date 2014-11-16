//
//  AppDelegate.swift
//  InternalTests
//
//  Created by Hoon H. on 11/16/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Cocoa
import Standards


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
		let	p1	=	"/Users/Eonil/Workshop/Incubation/Editor/Project/Subprojects/JSONDataSchemaInferencer/InternalTests"
//		let	u	=	NSURL(string: "file://\(p1)/events.json")!
//		let	u	=	NSURL(string: "file://\(p1)/example3.json")!
//		let	u	=	NSURL(string: "file://\(p1)/events2.json")!
//		let	u	=	NSURL(string: "file://\(p1)/example4.json")!
//		let	u	=	NSURL(string: "file://\(p1)/example5.json")!
		let	u	=	NSURL(string: "file://\(p1)/example6.json")!
		
		let	d	=	NSData(contentsOfURL: u)
		let	v	=	JSON.deserialise(d!)!
		
		
		let	d2	=	inferJSONSchema(v)
		let	ps1	=	d2.queryAllPathsForDataType(DiscoveryDataType.Composite)
		println("Paths for discovered composite types:")
		for p1 in ps1 {
			println("# \(p1.pathByStrippingAwayArrayComponents)")
			
			let	fs1	=	d2.queryDirectChildrenOfPath(p1)
			for f1 in fs1 {
				println("- \(f1.lastComponent!.fieldName!) = \(d2.pathSampleMap[f1]!.allKeys)")
			}
			
			println("")
		}
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

