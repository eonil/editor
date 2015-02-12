//
//  AppDelegate.swift
//  WorkbenchApp2
//
//  Created by Hoon H. on 2015/02/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import LLDBWrapper
import EditorDebuggingFeature




@NSApplicationMain
class AppDelegate: NSResponder, NSApplicationDelegate, ListenerControllerDelegate {
	
	@IBOutlet weak var mainWindow: NSWindow!
	@IBOutlet weak var localVariableWindow: NSWindow!
	
	let	sv1		=	NSScrollView()
	let	tv1		=	ExecutionStateTreeViewController()
	
	let	sv2		=	NSScrollView()
	let	tv2		=	VariableTreeViewController()
	
	let	dbg		=	LLDBDebugger()
	let	lcon	=	ListenerController()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		sv1.documentView		=	tv1.view
		mainWindow.contentView	=	sv1
		
		sv2.documentView		=	tv2.view
		localVariableWindow.contentView	=	sv2
		
		
		dbg.async	=	true
		
		let	f	=	NSBundle.mainBundle().bundlePath.stringByDeletingLastPathComponent.stringByAppendingPathComponent("Sample1")
		assert(NSFileManager.defaultManager().fileExistsAtPath(f))
	
		let	t	=	dbg.createTargetWithFilename(f, andArchname: LLDBArchDefault)
		let	b	=	t.createBreakpointByName("main")
		b.enabled	=	true
		
		let	p	=	t.launchProcessSimplyWithWorkingDirectory(f.stringByDeletingLastPathComponent)
		precondition(p.state == LLDBStateType.Stopped)
		
//		println(t.triple())
//		println(p.state.rawValue)
//		println(p.allThreads[0].allFrames[0]?.lineEntry)
//		println(p.allThreads[0].allFrames[0]?.functionName)
//		
////		tv1.debugger	=	dbg
////		if let f = dbg.allTargets.first?.process.allThreads.first?.allFrames.first {
////			tv2.data	=	f
////		}
		
		lcon.delegate	=	self
		lcon.startListening()
		p.addListener(lcon.listener, eventMask: LLDBProcess.BroadcastBit.StateChanged)
		
		//	Do not call `continue` on asynchronous debugger.
		//	It will stop at first if you call on it. Unexpected behavior.
//		p.`continue`()
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		lcon.stopListening()
		for t in dbg.allTargets {
			t.process.stop()
		}
	}

	
	
	
	@IBAction
	func performContinue(AnyObject?) {
		let	t	=	dbg.allTargets.first!
		t.process.`continue`()
	}
	@IBAction
	func performStop(AnyObject?) {
		let	t	=	dbg.allTargets.first!
		t.process.stop()
	}
	@IBAction
	func performStepInto(AnyObject?) {
		let	t	=	dbg.allTargets.first!
		t.process.allThreads.first!.stepInto()
	}
	@IBAction 
	func performStepOver(AnyObject?) {
		let	t	=	dbg.allTargets.first!
		t.process.allThreads.first!.stepOver()
	}
	@IBAction
	func performStepOut(AnyObject?) {
		let	t	=	dbg.allTargets.first!
		t.process.allThreads.first!.stepOut()
	}

	
	func listenerController(c: ListenerController, IsProcessingEvent e: LLDBEvent) {
		let	p	=	dbg.allTargets[0].process
		
		switch p.state {
		case .Running:
			tv1.debugger	=	nil
			tv2.data		=	nil
			
		default:
			tv1.debugger	=	dbg
			if let f = dbg.allTargets[0].process.allThreads[0].allFrames.first {
				tv2.data	=	f
			} else {
				tv2.data		=	nil
			}
		}
		
	}
}




































