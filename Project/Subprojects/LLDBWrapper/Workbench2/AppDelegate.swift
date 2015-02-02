//
//  AppDelegate.swift
//  Workbench2
//
//  Created by Hoon H. on 2015/01/29.
//
//

import Cocoa
import LLDBWrapper

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let	dbg	=	LLDBDebugger()
		dbg.async	=	false
		println(dbg)

		let	f	=	NSBundle.mainBundle().bundlePath.stringByDeletingLastPathComponent.stringByAppendingPathComponent("SampleProgram3")
		assert(NSFileManager.defaultManager().fileExistsAtPath(f))
		
		let	t	=	dbg.createTargetWithFilename(f, andArchname: LLDBArchDefault)
		let	b	=	t.createBreakpointByName("main")
		let	b1	=	t.createBreakpointByName("printf")
		b.enabled	=	true
		b1.enabled	=	true

		let	p	=	t.launchProcessSimplyWithWorkingDirectory(f.stringByDeletingLastPathComponent)

		println(p.state.rawValue)
		println(p.allThreads[0].allFrames[0]?.lineEntry)
		p.`continue`()

		println(p.state.rawValue)
		println(p.allThreads[0].allFrames[0]?.lineEntry)
		p.`continue`()
		
		println(p.state.rawValue)
		println(p.allThreads[0].allFrames[0]?.lineEntry)
		p.`continue`()
		
		println(p.state.rawValue)
		println(p.allThreads[0].numberOfFrames)
		println(p.allThreads[0].allFrames[0]?.lineEntry.line)
		p.`continue`()
		
		println("done")
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

