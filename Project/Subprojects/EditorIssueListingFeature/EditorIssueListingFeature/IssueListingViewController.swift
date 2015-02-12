//
//  IssueListingViewController.swift
//  EditorIssueListingFeature
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit


let	ROW_ADD_ANIMATION_EFFECT	=	NSTableViewAnimationOptions.allZeros
//let	ROW_ADD_ANIMATION_EFFECT	=	NSTableViewAnimationOptions.SlideDown		///	Really bad when issues are being added very frequently.


public protocol IssueListingViewControllerDelegate: class {
	///	If the issue origin is missing, `nil` will be passed to `file`.
	func issueListingViewControllerUserWantsToHighlightURL(file:NSURL?)
	func issueListingViewControllerUserWantsToHighlightIssue(issue:Issue)
//	func issueListingViewControllerUserWantsToNavigateToIssue(issue:Issue
}




public final class IssueListingViewController: NSViewController {
	public weak var delegate:IssueListingViewControllerDelegate?
	
	public func reset() {
		_repository.reset()
		self.outlineView.reloadData()
	}
	public func push(issues:[Issue]) {
		let	rs	=	_repository.push(issues)
//		self.outlineView.reloadData()
		
		self.outlineView.beginUpdates()
		for r in rs.groups {
			let	idxs	=	NSIndexSet(index: r.index)
			self.outlineView.insertItemsAtIndexes(idxs, inParent: nil, withAnimation: ROW_ADD_ANIMATION_EFFECT)
			self.outlineView.expandItem(r.node)
		}
		for r in rs.items {
			let	idxs	=	NSIndexSet(index: r.index)
			let	p		=	r.node.groupNode
			self.outlineView.insertItemsAtIndexes(idxs, inParent: p, withAnimation: ROW_ADD_ANIMATION_EFFECT)
		}
		self.outlineView.endUpdates()
		
		self.outlineView.sizeLastColumnToFit()		//	This have to be here to work properly. Seems doesn't work if there's no row.
	}
		
	public var outlineView:NSOutlineView {
		get {
			return	view as! NSOutlineView
		}
	}
	
	public override var view:NSView {
		get {
			return	super.view
		}
		//	You shouldn't set a new view.
		@availability(*,unavailable)
		set(v) {
			fatalError()
			precondition(v is NSOutlineView)
			super.view	=	v
		}
	}
	
	//	You shouldn't call this directly.
	@availability(*,unavailable)
	public override func loadView() {
		super.view	=	NSOutlineView()
	}
	
	//	You shouldn't call this directly.
	@availability(*,unavailable)
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		func makeTextColumn() -> NSTableColumn {
			let	TEXT		=	"TEXT"
			let	c			=	NSTableColumn()
			
			c.identifier	=	TEXT
			c.title			=	"Text"
			c.maxWidth		=	CGFloat.max
			c.minWidth		=	0
			return	c
		}
		
		self.outlineView.addTableColumn(makeTextColumn())
		self.outlineView.outlineTableColumn			=	(self.outlineView.tableColumns[0] as? NSTableColumn)!
		self.outlineView.selectionHighlightStyle	=	NSTableViewSelectionHighlightStyle.SourceList
		self.outlineView.rowSizeStyle				=	NSTableViewRowSizeStyle.Small
		self.outlineView.headerView					=	nil
		self.outlineView.setDataSource(self)
		self.outlineView.setDelegate(self)
	}
	
	////
	
	private let _repository		=	IssueRepository()
}














///	MARK:
///	MARK:	NSViewController Overridings

extension IssueListingViewController {

}
















///	MARK:
///	MARK:	NSOutlineViewDataSource

extension IssueListingViewController: NSOutlineViewDataSource {
	public func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item === nil {
			//	Root
			return	_repository.numberOfGroupNodes
		}
		if let g = item as? IssueGroupNode {
			return	g.numberOfItemNodes
		}
		return	0
	}
	public func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item === nil {
			return	_repository.groupNodeAtIndex(index)
		}
		if let g = item as? IssueGroupNode {
			return	g.itemNodeAtIndex(index)
		}
		fatalError("Unsupported type of parent item (\(item)).")
	}
	public func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		return	self.outlineView(outlineView, numberOfChildrenOfItem: item) > 0
	}
	public func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
		return	20
	}
}









///	MARK:
///	MARK:	NSOutlineViewDelegate

extension IssueListingViewController: NSOutlineViewDelegate {
	public func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		let	v1	=	NSImageView()
		let	v2	=	NSTextField()
		let	v	=	NSTableCellView()
		
		v2.editable			=	false
		v2.bordered			=	false
		v2.textColor		=	NSColor.textColor()
		v2.backgroundColor	=	NSColor.clearColor()
		v2.lineBreakMode	=	NSLineBreakMode.ByTruncatingTail
		
		v.addSubview(v1)
		v.addSubview(v2)
		v.imageView	=	v1
		v.textField	=	v2

		////
		
		if let g = item as? IssueGroupNode {
			v1.image		=	g.iconForUI
			v2.stringValue	=	g.textForUI
			v2.toolTip		=	g.textForUI
		}
		if let m = item as? IssueItemNode {
			v1.image		=	m.iconForUI
			v2.stringValue	=	m.textForUI
			v2.toolTip		=	m.textForUI
		}
		
		return	v
	}
	public func outlineViewSelectionDidChange(notification: NSNotification) {
		let	r	=	self.outlineView.selectedRow
		if r != -1 {
			let	m:AnyObject?	=	self.outlineView.itemAtRow(r)
			if let n = m as? IssueGroupNode {
				self.delegate?.issueListingViewControllerUserWantsToHighlightURL(n.origin)
			}
			if let n = m as? IssueItemNode {
				self.delegate?.issueListingViewControllerUserWantsToHighlightIssue(n.data)
			}
		}
	}
	///	I don't know why this doesn't work...
	///	http://stackoverflow.com/questions/15023589/different-tooltip-for-each-image-in-nstableview
	public func outlineView(outlineView: NSOutlineView, toolTipForCell cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, item: AnyObject, mouseLocation: NSPoint) -> String {
		if let n = item as? IssueGroupNode {
			return	n.textForUI
		}
		if let n = item as? IssueItemNode {
			return	n.textForUI
		}
		return	""
	}
}











