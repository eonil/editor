//
//  AppDelegate.swift
//  TestdriveApp
//
//  Created by Hoon H. on 2015/02/01.
//
//

import Cocoa
import LLDBWrapper





@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	
	let	sv	=	NSScrollView()
	let	tv	=	DebuggerTreeViewController()
	
	let	dbg	=	LLDBDebugger()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		sv.documentView		=	tv.view
		window.contentView	=	sv
		
		dbg.async	=	false
		
		let	f	=	NSBundle.mainBundle().bundlePath.stringByDeletingLastPathComponent.stringByAppendingPathComponent("SampleProgram3")
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
		tv.debugger	=	dbg
	}

	func applicationWillTerminate(aNotification: NSNotification) {
	}

	
	@IBAction @objc
	func performStepOver(AnyObject?) {
		tv.debugger	=	nil
		dbg.allTargets[0].process.allThreads[0].stepOver()
		tv.debugger	=	dbg
		
		let	d	=	dbg.allTargets[0].process.readFromStandardOutput()
		let	s	=	NSString(data: d, encoding: NSUTF8StringEncoding)
		println(s)
	}

}



class DebuggerTreeViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
	var	outlineView:NSOutlineView {
		get {
			return	view as NSOutlineView
		}
	}
	
	var	debugger:LLDBDebugger? {
		get {
			return	self.representedObject as LLDBDebugger?
		}
		set(v) {
			self.representedObject	=	v
		}
	}
	
	override var representedObject:AnyObject? {
		get {
			return	super.representedObject
		}
		set(v) {
			precondition(v == nil || v is LLDBDebugger)
			super.representedObject	=	v
			
			_rootNode	=	v == nil ? nil : DebuggerNode(v as LLDBDebugger)
			
			self.outlineView.reloadData()
			if _rootNode != nil {
				self.outlineView.expandItem(_rootNode, expandChildren: true)
			}
		}
	}
	
	override func loadView() {
		super.view	=	NSOutlineView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.outlineView.setDataSource(self)
		self.outlineView.setDelegate(self)
		
		let	tc1	=	NSTableColumn()
		self.outlineView.addTableColumn(tc1)
		self.outlineView.outlineTableColumn	=	tc1
	}
	
	func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	debugger == nil ? 0 : 1
		}
		let	n	=	item as NodeBase
		return	n.subnodes.count
	}
	func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			return	_rootNode!
		}
		let	n	=	item as NodeBase
		return	n.subnodes[index]
	}
	func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
		let	n	=	item as NodeBase
		return	n.label
	}
	func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		return	self.outlineView(outlineView, numberOfChildrenOfItem: item) > 0
	}
	
	////
	
	private var	_rootNode:DebuggerNode?
}


















class NodeBase {
	var	label		=	""
	var	subnodes	=	[] as [NodeBase]
}

class DebuggerNode: NodeBase {
	var	data:LLDBDebugger
	init(_ data:LLDBDebugger) {
		self.data		=	data
		
		super.init()
		self.label		=	"<Debugger>"
		self.subnodes	=	data.allTargets.map({ v in TargetNode(v) })
	}
}

class TargetNode: NodeBase {
	var	data:LLDBTarget
	init(_ data:LLDBTarget) {
		self.data		=	data
		
		super.init()
		self.label		=	data.triple()
		self.subnodes	=	data.process == nil ? [] : [ProcessNode(data.process)]
	}
}

class ProcessNode: NodeBase {
	var	data:LLDBProcess
	init(_ data:LLDBProcess) {
		self.data		=	data
		
		super.init()
		self.label		=	data.processID.description
		self.subnodes	=	data.allThreads.map({ v in ThreadNode(v) })
	}
}

class ThreadNode: NodeBase {
	var	data:LLDBThread
	init(_ data:LLDBThread) {
		self.data		=	data
		
		super.init()
		self.label		=	data.threadID.description
		self.subnodes	=	data.allFrames.filter({ v in v != nil }).map({ v in FrameNode(v!) })
	}
}

class FrameNode: NodeBase {
	var	data:LLDBFrame
	init(_ data:LLDBFrame) {
		self.data		=	data
		
		super.init()
		self.label		=	data.description
		self.subnodes	=	[]
	}
}





























