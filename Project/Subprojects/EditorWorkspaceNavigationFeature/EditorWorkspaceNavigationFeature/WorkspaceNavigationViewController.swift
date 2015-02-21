//
//  WorkspaceNavigationViewController.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

public final class WorkspaceNavigationViewController: NSViewController {
	
	public var URLRepresentation:NSURL? {
		get {
			return	super.representedObject as! NSURL?
		}
		set(v) {
			if v != (super.representedObject as! NSURL?) {
				if let u = URLRepresentation {
					_internalController.repository	=	nil
				}
				
				super.representedObject	=	v
				
				if let u = URLRepresentation {
					_internalController.repository	=	WorkspaceRepository(name: u.lastPathComponent!)
				}
				
				self.outlineView.reloadData()
			}
		}
	}
	
	@availability(*,unavailable)
	public override var representedObject:AnyObject? {
		get {
			return	URLRepresentation
		}
		set(v) {
			precondition(v is NSURL?, "Only `NSURL` value is allowed.")
			self.URLRepresentation	=	v as! NSURL?
		}
	}
	
	public override var view:NSView {
		willSet {
			fatalError("You cannot reset `view` of this object.")
		}
	}
	public override func loadView() {
		super.view	=	NSOutlineView()
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		assert(self.view is NSOutlineView)
		
		let	c1			=	NSTableColumn()
		c1.title		=	"Name"
		c1.identifier	=	COLUMN_NAME
		
		let	c2			=	NSTableColumn()
		c2.title		=	"Comment"
		c2.identifier	=	COLUMN_COMMENT
		
		outlineView.addTableColumn(c1)
		outlineView.addTableColumn(c2)
		outlineView.outlineTableColumn	=	c1
		
		outlineView.selectionHighlightStyle	=	NSTableViewSelectionHighlightStyle.SourceList
		outlineView.rowSizeStyle			=	NSTableViewRowSizeStyle.Small
		outlineView.menu					=	_menuController.menu
		
		outlineView.setDataSource(_internalController)
		outlineView.setDelegate(_internalController)
	}
	
	////
	
	private let	_internalController		=	InternalController()
	private let _menuController			=	WorkspaceNavigationContextMenuController()
}

private extension WorkspaceNavigationViewController {
	var outlineView:NSOutlineView {
		get {
			return	self.view as! NSOutlineView
		}
	}
}


























///	MARK:
///	MARK:	InternalController

private final class InternalController: NSObject {
	var repository		=	nil as WorkspaceRepository?
	weak var owner:WorkspaceNavigationViewController! {
		willSet {
			assert(owner == nil)
		}
	}
}

extension InternalController: NSOutlineViewDataSource {
	@objc
	func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		let n	=	item as! WorkspaceNode
		return	n.children.count > 0
	}
	@objc
	func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	repository == nil ? 0 : 1
		}
		let n	=	item as! WorkspaceNode
		return	n.children.count
	}
	@objc
	func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			return	repository!.root
		}
		let	n	=	item as! WorkspaceNode
		return	n.children[index]
	}
	@objc
	func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
		return	item as! WorkspaceNode
	}
	@objc
	func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		let	v	=	CellView()
		v.nodeRepresentation	=	item as! WorkspaceNode
		return	v
	}
}


extension InternalController: NSOutlineViewDelegate {
	
}



private final class CellView: NSTableCellView {
	override init() {
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("Unsupported initializer.")
	}
	
	@availability(*,unavailable)
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		
		let	v1	=	NSImageView()
		let	v2	=	NSTextField()
		self.addSubview(v1)
		self.addSubview(v2)
		
		v2.bordered			=	false
		v2.backgroundColor	=	NSColor.clearColor()
		
		self.imageView	=	v1
		self.textField	=	v2
	}
	
	
	
	var nodeRepresentation:WorkspaceNode? {
		get {
			return	super.objectValue as! WorkspaceNode?
		}
		set(v) {
			super.objectValue	=	v
			
			imageView!.image		=	nil
			textField!.stringValue	=	v!.name
		}
	}
	
	@availability(*,unavailable)
	override var objectValue:AnyObject? {
		willSet(v) {
			precondition(v is WorkspaceNode, "Only `WorkspaceNode` type is acceptable.")
		}
//		get {
//			
//		}
//		set(v) {
//			
//		}
	}
}
















private let	COLUMN_NAME		=	"NAME"
private let	COLUMN_COMMENT	=	"COMMENT"









