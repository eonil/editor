//
//  ExecutionStateTreeViewController.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import EditorUIComponents






public protocol ExecutionStateTreeViewControllerDelegate: class {
	///	Called user selected a new node.
	///
	///	:param:	frame	Can be `nil` .
	func executionStateTreeViewControllerDidSelectFrame(frame:LLDBFrame?)
}





///	This is a snapshot display. You need to set a new snapshot to display updated state.
///	This object REQUIRES delegate for every events. You must set a valid `delegate` object.
///
///	This view-controller incorporates a scrolling support, so you should not wrap this in a
///	scroll-view.
public final class ExecutionStateTreeViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
	public weak var delegate:ExecutionStateTreeViewControllerDelegate? {
		willSet {
			assert(delegate == nil)
		}
	}
	
	public var snapshot:Snapshot? {
		didSet {
			super.representedObject	=	self.snapshot?.rootNode
			self._rootNode			=	self.snapshot?.rootNode
			
			self.outlineView.reloadData()
			for n in _rootNode?.subnodes ||| [] {
				self.outlineView.expandItem(n, expandChildren: true)
			}
		}
	}
	
	
	
	
	
	@availability(*,unavailable)
	public final override var representedObject:AnyObject? {
		get {
			deletedPropertyFatalError()
		}
		set(v) {
			deletedPropertyFatalError()
		}
	}
	
	
	public final override var view:NSView {
		willSet {
			fatalError("You cannot replace view of this view-controller. It is prohibited by design.")
		}
	}
	public override func loadView() {
		super.view	=	NSScrollView()
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		assert(super.view is NSScrollView)
		
		scrollView.hasVerticalScroller	=	true
		scrollView.hasHorizontalRuler	=	false
		scrollView.documentView			=	outlineView
		
		////
		
		self.outlineView.setDataSource(self)
		self.outlineView.setDelegate(self)
		
		self.outlineView.headerView		=	nil
		self.outlineView.rowHeight		=	Palette.defaultLineHeight
		
		let	tc1	=	NSTableColumn()
		self.outlineView.addTableColumn(tc1)
		self.outlineView.outlineTableColumn	=	tc1
	}
	
	public func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	_rootNode?.subnodes.count ||| 0
		}
		let	n	=	item as! NodeBase
		return	n.subnodes.count
	}
	public func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			return	_rootNode!.subnodes[index]
		}
		let	n	=	item as! NodeBase
		return	n.subnodes[index]
	}
//	public func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
//		let	n	=	item as NodeBase
//		return	n.label
//	}
	public func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		return	self.outlineView(outlineView, numberOfChildrenOfItem: item) > 0
	}
	
	public func outlineView(outlineView: NSOutlineView, rowViewForItem item: AnyObject) -> NSTableRowView? {
		let	v	=	DarkVibrancyAwareTableRowView()
//		v.appearance	=	outlineView.appearance
		return	v
	}
	public func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		let	n	=	item as! NodeBase
		let	v	=	AttributedStringTableCellView()
		v.attributedString	=	Text(n.label).setFont(Palette.defaultFont()).setTextColor(NSColor.labelColor()).attributedString
//		v.appearance		=	outlineView.appearance
		return	v
	}
	
	public func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
		assert(self.delegate != nil)
		
		if let fn = item as? FrameNode {
			self.delegate!.executionStateTreeViewControllerDidSelectFrame(fn.data)
		} else {
			self.delegate!.executionStateTreeViewControllerDidSelectFrame(nil)
		}
		return	true
	}
	
	////
	
	internal let outlineView		=	NSOutlineView()
	
	internal var scrollView:NSScrollView {
		get {
			return	view as! NSScrollView
		}
	}
	
	////
	
	private var	_rootNode:DebuggerNode?
}







public extension ExecutionStateTreeViewController {
	public struct Snapshot {
		public init(_ debugger:LLDBDebugger) {
			self.rootNode	=	DebuggerNode(debugger)
		}
		
		private let	rootNode:DebuggerNode
	}
}


































///	MARK:
///	MARK:	Node Classes



private class NodeBase {
	var	label		=	NSAttributedString()
	var	subnodes	=	[] as [NodeBase]
}

private class DebuggerNode: NodeBase {
	var	data:LLDBDebugger
	init(_ data:LLDBDebugger) {
		self.data		=	data
		
		super.init()
		self.label		=	Text("Debugger").attributedString
		self.subnodes	=	data.allTargets.map({ v in TargetNode(v) })
	}
}

private class TargetNode: NodeBase {
	var	data:LLDBTarget
	init(_ data:LLDBTarget) {
		self.data		=	data
		
		super.init()
		
		self.label		=	Text("\(data.executableFileSpec().filename) (\(data.triple()))").attributedString
		self.subnodes	=	data.process == nil ? [] : [ProcessNode(data.process)]
	}
}

private class ProcessNode: NodeBase {
	var	data:LLDBProcess
	init(_ data:LLDBProcess) {
		self.data		=	data
		super.init()
		
		let	ps2	=	data.state == LLDBStateType.Exited ? [
			processStateDescription(data.state),
			"=",
			data.exitStatus.description,
		] : [
			processStateDescription(data.state),
		]
		let	ps3	=	ps2 + (data.exitDescription == nil ? [] : [quote(data.exitDescription)])
		let	s3	=	join(" ", ps3.filter({ v in v != "" }))
		let	ps4	=	[
			"PID",
			"=",
			data.processID.description,
			brace(s3),
		]
		
		let	s			=	join(" ", ps4.filter({ v in v != "" }))
		self.label		=	Text(s).attributedString
		self.subnodes	=	data.allThreads.map({ v in ThreadNode(v) })
	}
}

private class ThreadNode: NodeBase {
	var	data:LLDBThread
	init(_ data:LLDBThread) {
		self.data		=	data
		super.init()

		let	ps			=	[
			"TID",
			"=",
			data.threadID.description,
			quote(data.name),
			quote(data.queueName),
			brace(data.stopDescription()),
		]
		
		let	s			=	join(" ", ps.filter({ v in v != "" }))
		self.label		=	Text(s).attributedString
		self.subnodes	=	data.allFrames.filter({ v in v != nil }).map({ v in FrameNode(v!) })
	}
}

private class FrameNode: NodeBase {
	var	data:LLDBFrame
	init(_ data:LLDBFrame) {
		self.data		=	data
		super.init()
		
		let	s			=	"\(data.frameID) \(data.functionName)"
		self.label		=	Text(s).attributedString
		self.subnodes	=	[]
	}
}











private func processStateDescription(s:LLDBStateType) -> String {
	switch s {
	case .Attaching:		return	"attached"
	case .Connected:		return	"connected"
	case .Crashed:			return	"crashed"
	case .Detached:			return	"detached"
	case .Exited:			return	"exited"
	case .Invalid:			return	"invalid"
	case .Launching:		return	"launching"
	case .Running:			return	"running"
	case .Stepping:			return	"stepping"
	case .Stopped:			return	"stopped"
	case .Suspended:		return	"suspended"
	case .Unloaded:			return	"unloaded"
	}
}
private func threadStopReasonDescription(s:LLDBStopReason) -> String {
	switch s {
	case .Breakpoint:		return	"breakpoint"
	case .Exception:		return	"exception"
	case .Exec:				return	"exec"
	case .Instrumentation:	return	"instrumentation"
	case .Invalid:			return	"invalid"
	case .None:				return	"none"
	case .PlanComplete:		return	"plan complete"
	case .Signal:			return	"signal"
	case .ThreadExiting:	return	"thread exiting"
	case .Trace:			return	"trace"
	case .Watchpoint:		return	"watchpoint"
	}
}

private func quote(s:String?) -> String {
	if let s1 = s {
		return	"`\(s!)`"
	}
	return	""
}
private func brace(s:String?) -> String {
	if let s1 = s {
		return	"(\(s!))"
	}
	return	""
}

















