//
//  FileTreeViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

class FileTreeViewController : NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
	
	let	userIsWantingToEditFileAtPath	=	Notifier<String>()
	
	private	var	_root:FileNode?
	
	var pathRepresentation:String? {
		get {
			return	self.representedObject as String?
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
			precondition(v is String)
			super.representedObject	=	v
			
			if let v2 = v as String? {
				_root	=	FileNode(path: pathRepresentation!)
			} else {
				_root	=	nil
			}
			
			self.outlineView.reloadData()
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
		let	n1	=	item as FileNode?
		if let n2 = n1 {
			if let ns3 = n2.subnodes {
				return	ns3.count
			} else {
				return	0
			}
		} else {
			return	_root == nil ? 0 : 1
		}
	}
	func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		let	n1	=	item as FileNode?
		if let n2 = n1 {
			let ns3 = n2.subnodes!
			return	ns3[index]
		} else {
			return	_root!
		}
	}
//	func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
//		let	n1	=	item as FileNode
//		let	ns2	=	n1.subnodes
//		return	ns2 != nil
//	}
	func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		let	n1	=	item as FileNode
		let	ns2	=	n1.subnodes
		return	ns2 != nil
	}
//	func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
//		let	n1	=	item as FileNode
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

		let	n1	=	item as FileNode
		assert(n1.existing)
		iv1.image						=	NSWorkspace.sharedWorkspace().iconForFile(n1.absolutePath)
		cv1.textField!.stringValue		=	n1.relativePath
		cv1.textField!.bordered			=	false
		cv1.textField!.backgroundColor	=	NSColor.clearColor()
		cv1.textField!.editable			=	false
		(cv1.textField!.cell() as NSCell).lineBreakMode	=	NSLineBreakMode.ByTruncatingHead
		return	cv1
	}
	
	
	
	func outlineViewSelectionDidChange(notification: NSNotification) {
		let	idx1	=	self.outlineView.selectedRow
		let	n1		=	self.outlineView.itemAtRow(idx1) as FileNode
		userIsWantingToEditFileAtPath.signal(n1.absolutePath)
	}
}







final class FileNode {
	let			relativePath:String
	let			supernode:FileNode?
	
	private var _subnodes:[FileNode]?
	
	///	Makes a root node.
	init(path:String) {
		self.relativePath	=	path
	}
	init(supernode:FileNode, relativePath:String) {
		self.supernode		=	supernode
		self.relativePath	=	relativePath
	}
	var absoluteURL:NSURL {
		get {
			return	NSURL(fileURLWithPath: absolutePath)!
		}
	}
	var	absolutePath:String {
		get {
			return	supernode == nil ? relativePath : supernode!.absolutePath.stringByAppendingPathComponent(relativePath)
		}
	}
	var	existing:Bool {
		get {
			return	NSFileManager.defaultManager().fileExistsAtPath(absolutePath)
		}
	}
	
	var	data:NSData? {
		get {
			if NSFileManager.defaultManager().fileExistsAtPathAsDataFile(absolutePath) {
				return	NSData(contentsOfFile: absolutePath)
			}
			return	nil
		}
	}
	var subnodes:[FileNode]? {
		get {
			
			if NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(absolutePath) {
				if _subnodes == nil {
					_subnodes	=	[]
					let	u1	=	absoluteURL
					let	e1	=	NSFileManager.defaultManager().enumeratorAtURL(u1, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles | NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, errorHandler: { (url:NSURL!, error:NSError!) -> Bool in
						return	false
					})
					let	e2	=	e1!
					while let o1 = e2.nextObject() as? NSURL {
						let	p2	=	o1.path!.lastPathComponent
						let	n1	=	FileNode(supernode: self, relativePath: p2)
						_subnodes!.append(n1)
					}
				}
				return	_subnodes!
			}
			return	nil
			
//			if NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(absolutePath) {
//				if _subnodes == nil {
//					_subnodes	=	[]
//					let	e1	=	NSFileManager.defaultManager().enumeratorAtPath(absolutePath)!
//					e1.skipDescendants()
//					while let o1 = e1.nextObject() as? String {
//						let	n1	=	FileNode(path: o1)
//						_subnodes!.append(n1)
//					}
//				}
//				return	_subnodes!
//			}
//			return	nil
		}
	}
}




private let	NAME	=	"NAME"

