//
//  AppDelegate.swift
//  WorkbenchApp2
//
//  Created by Hoon H. on 2015/02/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import LLDBWrapper





@NSApplicationMain
class AppDelegate: NSResponder, NSApplicationDelegate {
	
	@IBOutlet weak var mainWindow: NSWindow!
	@IBOutlet weak var localVariableWindow: NSWindow!
	
	let	sv1		=	NSScrollView()
	let	tv1		=	DebuggerTreeViewController()
	
	let	sv2		=	NSScrollView()
	let	tv2		=	LocalVariableTreeViewController()
	
	let	dbg	=	LLDBDebugger()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		sv1.documentView		=	tv1.view
		mainWindow.contentView	=	sv1
		
		sv2.documentView		=	tv2.view
		localVariableWindow.contentView	=	sv2
		
		
		dbg.async	=	false
		
		let	f	=	NSBundle.mainBundle().bundlePath.stringByDeletingLastPathComponent.stringByAppendingPathComponent("Sample1")
		assert(NSFileManager.defaultManager().fileExistsAtPath(f))
	
		let	t	=	dbg.createTargetWithFilename(f, andArchname: LLDBArchDefault)
		let	b	=	t.createBreakpointByName("main")
		b.enabled	=	true
		
		let	p	=	t.launchProcessSimplyWithWorkingDirectory(f.stringByDeletingLastPathComponent)
		
		println(t.triple())
		println(p.state.rawValue)
		println(p.allThreads[0].allFrames[0]?.lineEntry)
		println(p.allThreads[0].allFrames[0]?.functionName)
		
//		t.process.`continue`()
		
		tv1.debugger	=	dbg
		if let f = dbg.allTargets.first?.process.allThreads.first?.allFrames.first {
			tv2.data	=	f
		}
	}

	func applicationWillTerminate(aNotification: NSNotification) {
	}

	
	@IBAction 
	func performStepOver(AnyObject?) {
		tv1.debugger	=	nil
		dbg.allTargets[0].process.allThreads[0].stepOver()
		tv1.debugger	=	dbg
		
		tv2.data		=	nil
		if let f = dbg.allTargets[0].process.allThreads[0].allFrames.first {
			tv2.data	=	f
		}
		
		let	d	=	dbg.allTargets[0].process.readFromStandardOutput()
		let	s	=	NSString(data: d, encoding: NSUTF8StringEncoding)
		println(s)
	}

}

