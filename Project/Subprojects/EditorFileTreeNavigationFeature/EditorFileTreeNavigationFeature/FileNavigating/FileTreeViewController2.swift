////
////  FileTreeViewController2.swift
////  RustCodeEditor
////
////  Created by Hoon H. on 11/12/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//
//class FileTreeViewController2 : NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
//	
//	let	userIsWantingToEditFileAtPath	=	Notifier<String>()
//	
//	private	var	_root:FileNode2?
//	private var	_errorChannel			=	nil as Observer<NSError>?
//	private var	_invalidationChannel	=	nil as Observer<FileNode2>?
//	
//	private func onError(e:NSError) {
//		NSAlert(error: e).runModal()
//	}
//	private func onInvalidation(n:FileNode2) {
//		self.outlineView.reloadItem(n, reloadChildren: true)
//	}
//	
//	var URLRepresentation:NSURL? {
//		get {
//			return	self.representedObject as NSURL?
//		}
//		set(v) {
//			self.representedObject	=	v
//		}
//	}
//	override var representedObject:AnyObject? {
//		willSet(v) {
//			if let r2 = _root {
//				_root!.notifyAnyError.unregister(_errorChannel!)
//			}
//			
//			precondition(v is NSURL)
//		}
//		didSet {
//			if let u2 = URLRepresentation {
//				_root					=	FileNode2(absoluteURL: u2)
//				_errorChannel			=	channel(_root!.notifyAnyError, onError)
//				_invalidationChannel	=	channel(_root!.notifyInvalidationOfNode, onInvalidation)
//			} else {
//				_root	=	nil
//			}
//			
//			self.outlineView.reloadData()
//		}
//	}
//	
//	var outlineView:NSOutlineView {
//		get {
//			return	self.view as NSOutlineView
//		}
//		set(v) {
//			self.view	=	v
//		}
//	}
//	
//	override func loadView() {
//		super.view	=	NSOutlineView()
//	}
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		let	col1	=	NSTableColumn(identifier: NAME, title: "Name", width: 100)
//
//		outlineView.focusRingType	=	NSFocusRingType.None
//		outlineView.headerView		=	nil
//		outlineView.addTableColumn <<< col1
//		outlineView.outlineTableColumn		=	col1
//		outlineView.rowSizeStyle			=	NSTableViewRowSizeStyle.Small
//		outlineView.selectionHighlightStyle	=	NSTableViewSelectionHighlightStyle.SourceList
//		outlineView.sizeLastColumnToFit()
//		
//		outlineView.setDataSource(self)
//		outlineView.setDelegate(self)
//		
//	}
//	
//	
//	
//	
////	func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
////		return	16
////	}
//	
//	func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
//		let	n1	=	item as FileNode2?
//		if let n2 = n1 {
//			return	n2.subnodes.count
//		} else {
//			return	_root == nil ? 0 : 1
//		}
//	}
//	func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
//		let	n1	=	item as FileNode2?
//		if let n2 = n1 {
//			return	n2.subnodes[index]
//		} else {
//			return	_root!
//		}
//	}
////	func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
////		let	n1	=	item as FileNode2
////		let	ns2	=	n1.subnodes
////		return	ns2 != nil
////	}
//	func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
//		let	n1	=	item as FileNode2
//		return	n1.directory
//	}
////	func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
////		let	n1	=	item as FileNode2
////		return	n1.relativePath
////	}
//	func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
//		let	tv1	=	NSTextField()
//		let	iv1	=	NSImageView()
//		let	cv1	=	NSTableCellView()
//		cv1.textField	=	tv1
//		cv1.imageView	=	iv1
//		cv1.addSubview(tv1)
//		cv1.addSubview(iv1)
//
//		let	n1	=	item as FileNode2
//		assert(n1.existing)
//		iv1.image						=	NSWorkspace.sharedWorkspace().iconForFile(n1.absolutePath)
//		cv1.textField!.stringValue		=	n1.displayName
//		cv1.textField!.bordered			=	false
//		cv1.textField!.backgroundColor	=	NSColor.clearColor()
//		cv1.textField!.editable			=	false
//		(cv1.textField!.cell() as NSCell).lineBreakMode	=	NSLineBreakMode.ByTruncatingHead
//		return	cv1
//	}
//	
//	
//	
//	func outlineViewSelectionDidChange(notification: NSNotification) {
////		let	idx1	=	self.outlineView.selectedRow
////		let	n1		=	self.outlineView.itemAtRow(idx1) as FileNode2
////		userIsWantingToEditFileAtPath.signal(n1.absolutePath)
//	}
//}
//
//
//
//
//
//
//
//
//private let	NAME	=	"NAME"
//
//
