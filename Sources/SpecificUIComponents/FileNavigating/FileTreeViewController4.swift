//
//  FileTreeViewController4.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

class FileTreeViewController4 : NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
	
	let	userIsWantingToEditFileAtPath	=	Notifier<String>()
	
	private	var	_fileTreeRepository		=	nil as FileTreeRepository4?
	private	var	_fileSystemMonitor		=	nil as FileSystemMonitor?
	
	private var	_channelsHolding:Any?
	
	var URLRepresentation:NSURL? {
		get {
			return	self.representedObject as NSURL?
		}
		set(v) {
			self.representedObject	=	v
		}
	}
	private func onError(e:NSError) {
		NSAlert(error: e).runModal()
	}
	private func onAddingNodes(ns:[FileNode4]) {
		let	ns2	=	ns.map({$0.supernode}).filter({$0 != nil}).map({$0!})
		let	ns3	=	deduplicate(ns2)
		println(ns3)
		
		self.outlineView.beginUpdates()
		for n in ns3 {
			self.outlineView.reloadItem(n, reloadChildren: true)
		}
		self.outlineView.endUpdates()
	}
	private func onRemovingNodes(ns:[FileNode4]) {
//		let	ns2	=	ns.map({$0.supernode}).filter({$0 != nil}).map({$0!})
//		let	ns3	=	deduplicate(ns2)
//		
//		self.outlineView.beginUpdates()
//		for n in ns3 {
//			self.outlineView.reloadItem(n, reloadChildren: true)
//		}
//		self.outlineView.endUpdates()
		
		self.outlineView.beginUpdates()
		for n in ns {
			let	idx1	=	self.outlineView.rowForItem(n)
			self.outlineView.removeItemsAtIndexes(NSIndexSet(index: idx1), inParent: n.supernode!, withAnimation: NSTableViewAnimationOptions.EffectFade)
		}
		self.outlineView.endUpdates()
	}
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	override var representedObject:AnyObject? {
		willSet(v) {
			precondition(v is NSURL)
			_channelsHolding	=	nil
			_fileSystemMonitor	=	nil
			_fileTreeRepository	=	nil
		}
		didSet {
			if let v3 = URLRepresentation {
				_fileTreeRepository	=	FileTreeRepository4(rootlink: v3)
				_fileTreeRepository!.reload()
				
				_fileSystemMonitor	=	FileSystemMonitor(v3)
			}
			self.outlineView.reloadData()
			
			_channelsHolding	=	connectMonitorToTree(_fileSystemMonitor!, _fileTreeRepository!, outlineView)
		}
	}
	
	var outlineView:NSOutlineView {
		get {
			return	self.view as NSOutlineView
		}
		set(v) {
			self.view	=	v
		}
	}
	override func loadView() {
		super.view	=	NSOutlineView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let	col1	=	NSTableColumn(identifier: NAME, title: "Name", width: 100)

		outlineView.focusRingType	=	NSFocusRingType.None
		outlineView.headerView		=	nil
		outlineView.addTableColumn <<< col1
		outlineView.outlineTableColumn		=	col1
		outlineView.rowSizeStyle			=	NSTableViewRowSizeStyle.Small
		outlineView.selectionHighlightStyle	=	NSTableViewSelectionHighlightStyle.SourceList
		outlineView.sizeLastColumnToFit()
		
		outlineView.setDataSource(self)
		outlineView.setDelegate(self)
	}
	
	
	
	
//	func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
//		return	16
//	}
	
	func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		let	n1	=	item as FileNode4?
		if let n2 = n1 {
			if n2.subnodes.count == 0 {
				n2.reloadSubnodes()
				for u1 in n2.subnodes.links {
					_fileSystemMonitor!.addWatchForURL(u1)
				}
			}
			return	n2.subnodes.count
		} else {
			return	_fileTreeRepository?.root == nil ? 0 : 1
		}
	}
	func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		let	n1	=	item as FileNode4?
		if let n2 = n1 {
			return	n2.subnodes[index]
		} else {
			return	_fileTreeRepository!.root!
		}
	}
//	func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
//		let	n1	=	item as FileNode4
//		let	ns2	=	n1.subnodes
//		return	ns2 != nil
//	}
	func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		let	n1	=	item as FileNode4
		return	n1.directory
	}
//	func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
//		let	n1	=	item as FileNode4
//		return	n1.relativePath
//	}
	func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		let	tv1	=	NSTextField()
		let	iv1	=	NSImageView()
		let	cv1	=	NSTableCellView()
		cv1.textField	=	tv1
		cv1.imageView	=	iv1
		cv1.addSubview(tv1)
		cv1.addSubview(iv1)

		let	n1	=	item as FileNode4
		assert(n1.existing)
		iv1.image						=	NSWorkspace.sharedWorkspace().iconForFile(n1.link.path!)
		cv1.textField!.stringValue		=	n1.displayName
		cv1.textField!.bordered			=	false
		cv1.textField!.backgroundColor	=	NSColor.clearColor()
		cv1.textField!.editable			=	false
		(cv1.textField!.cell() as NSCell).lineBreakMode	=	NSLineBreakMode.ByTruncatingHead
		return	cv1
	}
	
	
	
	func outlineViewSelectionDidChange(notification: NSNotification) {
//		let	idx1	=	self.outlineView.selectedRow
//		let	n1		=	self.outlineView.itemAtRow(idx1) as FileNode4
//		userIsWantingToEditFileAtPath.signal(n1.absolutePath)
	}
	func outlineViewItemDidCollapse(notification: NSNotification) {
		assert(notification.name == NSOutlineViewItemDidCollapseNotification)
		let	n1	=	notification.userInfo!["NSObject"]! as FileNode4
		for u1 in n1.subnodes.links {
			_fileSystemMonitor!.removeWatchForURL(u1)
		}
		n1.resetSubnodes()
	}
}


























private let	NAME	=	"NAME"






///	Keep the returned object to keep the connection.
private func connectMonitorToTree(m:FileSystemMonitor, t:FileTreeRepository4, v:NSOutlineView) -> Any {
	let reloadUIForNode	=	{ [unowned v] (n:FileNode4)->() in
		v.reloadItem(n, reloadChildren: true)
	}
	func onVNodeEvent(u:NSURL) {
		if let n1 = t[u] {
			if n1.existing {
				n1.reloadSubnodes()
				reloadUIForNode(n1)
			} else {
				n1.supernode!.reloadSubnodes()
				reloadUIForNode(n1.supernode!)
			}
		} else {
			t.createNodeForURL(u)
			reloadUIForNode(t[u]!)
		}
	}
	
	let	ch1	=	channel(m.notifyEventOnWatchForURL, onVNodeEvent)
	return	(ch1)
}











