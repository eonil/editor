//
//  VariableTreeViewController.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper

public final class VariableTreeViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
	public var	outlineView:NSOutlineView {
		get {
			return	view as NSOutlineView
		}
	}
	
	public var	data:LLDBFrame? {
		get {
			return	self.representedObject as LLDBFrame?
		}
		set(v) {
			self.representedObject	=	v
		}
	}
	
	public override var representedObject:AnyObject? {
		get {
			return	super.representedObject
		}
		set(v) {
			precondition(v == nil || v is LLDBFrame)
			super.representedObject	=	v
			
			_rootNode	=	v == nil ? nil : FrameNode(v as LLDBFrame)
			
			self.outlineView.reloadData()
			if _rootNode != nil {
				for m in _rootNode?.subnodes ||| [] {
					self.outlineView.expandItem(m, expandChildren: true)
				}
			}
		}
	}
	
	public override func loadView() {
		super.view	=	NSOutlineView()
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		self.outlineView.setDataSource(self)
		self.outlineView.setDelegate(self)
		
//		self.outlineView.rowSizeStyle	=	NSTableViewRowSizeStyle.Large
		self.outlineView.rowHeight		=	14
		
		func makeColumn(c:Column) -> NSTableColumn {
			let	c1			=	NSTableColumn()
			c1.identifier	=	c.rawValue
			c1.title		=	c.label
			return	c1
		}
		
		self.outlineView.addTableColumn(makeColumn(Column.Label))
//		self.outlineView.addTableColumn(makeColumn(Column.Kind))
//		self.outlineView.addTableColumn(makeColumn(Column.Expression))
		self.outlineView.outlineTableColumn	=	(self.outlineView.tableColumns[0] as? NSTableColumn)!
	}
	
	public func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	_rootNode?.subnodes.count ||| 0;
		}
		let	n	=	item as NodeBase
		return	n.subnodes.count
	}
	public func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			return	_rootNode!.subnodes[index]
		}
		let	n	=	item as NodeBase
		return	n.subnodes[index]
	}
//	public func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
//		let	n	=	item as NodeBase
//		return	n.presentations[Column(rawValue: tableColumn!.identifier)!]
//	}
	public func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		return	self.outlineView(outlineView, numberOfChildrenOfItem: item) > 0
	}
//	public func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
//		return	NSFont.smallSystemFontSize() * 1.2
//	}
	public func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		if let n = item as? VariableNode {
			let	v				=	AttributedStringTableCellView()
			v.attributedString	=	makePresentationText(n)
			return	v
		} else {
			fatalError("Unsupported item `\(item)`.")
		}
	}
	
	////
	
	private var	_rootNode:FrameNode?
}


private func makePresentationText(n:VariableNode) -> NSAttributedString {
	let	a	=	n.presentations[Column.Label]!
	let	b	=	n.presentations[Column.Kind]!
	let	c	=	n.presentations[Column.Expression]!
	
	let	f	=	Palette.defaultFont()
	let	f1	=	Palette.defaultBoldFont()
	
	let	a1	=	Text("\(a)").setFont(f1).setTextColor(NSColor.textColor())
	let	b1	=	Text(" = (\(b))").setFont(f).setTextColor(NSColor.textColor().colorWithAlphaComponent(0.5))
	let	c1	=	Text(" \(c)").setFont(f).setTextColor(NSColor.textColor())
	
	let	d	=	a1 + b1 + c1

	return	d.attributedString
}



































private enum Column: String {
	case Label			=	"LABEL"
	case Kind			=	"KIND"
	case Expression		=	"EXPRESSION"
}

extension Column {
	var label:String {
		get {
			switch self {
			case .Label:		return	"Name"
			case .Kind:			return	"Type"
			case .Expression:	return	"Expression"
			}
		}
	}
}

















private class NodeBase {
	var	presentations:[Column:String]	=	[:]
	var	subnodes:[NodeBase]				=	[]
	init() {
	}
}

private class FrameNode: NodeBase {
	let	source:LLDBFrame
	init(_ source:LLDBFrame) {
		self.source				=	source
		super.init()
		self.presentations		=	[
			Column.Label		:	"<Frame>",
			Column.Kind			:	"",
			Column.Expression	:	"",
		]
		
		if let vs = source.variablesWithArguments(true, locals: true, statics: true, inScopeOnly: true, useDynamic: LLDBDynamicValueType.DynamicCanRunTarget) {
			self.subnodes		=	vs.allAvailableValues.map({ v in VariableNode(v) })
		} else {
			self.subnodes		=	[]
		}
	}
}
private class VariableNode: NodeBase {
	let	source:LLDBValue
	init(_ source:LLDBValue) {
		self.source				=	source
		super.init()
		
		let	od	=	source.valueExpression?
		let	od1	=	od == nil ? "" : od!
		
		self.presentations		=	[
			Column.Label		:	source.name,
			Column.Kind			:	source.typeName,
			Column.Expression	:	od1,
		]
		self.subnodes			=	source.allChildren.filter({ v in v != nil }).map({ v in VariableNode(v!) })
	}
}












