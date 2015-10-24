//
//  VariableTreeView.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/28.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import LLDBWrapper
import EditorCommon
import EditorUICommon

public class VariableTreeView: CommonView {

	public var onUserDidSelectVariable	:	(()->())?
	public var onUserWillDeselectVariable	:	(()->())?

	public func reconfigure(frame: LLDBFrame?) {
		_dataTree.reconfigure(frame?.variablesWithArguments(true, locals: true, statics: true, inScopeOnly: true, useDynamic: LLDBDynamicValueType.DynamicCanRunTarget).allAvailableValues ?? [])
		_outlineView.reloadData()
	}

	public private(set) var currentValue: LLDBValue? {
		willSet {
			if currentValue != nil {
				onUserWillDeselectVariable?()
			}
		}
		didSet {
			if currentValue != nil {
				onUserDidSelectVariable?()
			}
		}
	}

	///

	public override func installSubcomponents() {
		super.installSubcomponents()
		_install()
	}
	public override func deinstallSubcomponents() {
		_deinstall()
		super.deinstallSubcomponents()
	}
	public override func layoutSubcomponents() {
		super.layoutSubcomponents()
		_layout()
	}

	///

	private let	_scrollView	=	NSScrollView()
	private let	_outlineView	=	_instantiateOutlineView()
	private let	_outlineAgent	=	_VariableTreeAgent()
	private let	_dataTree	=	VariableTree()

	///

	private func _install() {
		_outlineAgent.owner		=	self
		_outlineView.setDataSource(_outlineAgent)
		_outlineView.setDelegate(_outlineAgent)
		_scrollView.documentView	=	_outlineView
		addSubview(_scrollView)
	}
	private func _deinstall() {
		_scrollView.removeFromSuperview()
		_scrollView.documentView	=	nil
		_outlineView.setDataSource(nil)
		_outlineView.setDelegate(nil)
		_outlineAgent.owner		=	nil
	}
	private func _layout() {
		_scrollView.frame		=	bounds
	}

	///

	private func _didInsertSubnodes(range: Range<Int>, of supernode: VariableNode?) {
		let	idxs	=	NSIndexSet(range)
		_outlineView.insertItemsAtIndexes(idxs, inParent: supernode, withAnimation: NSTableViewAnimationOptions.EffectNone)
	}
	private func _willDeleteSubnodes(range: Range<Int>, of supernode: VariableNode?) {
		let	idxs	=	NSIndexSet(range)
		_outlineView.removeItemsAtIndexes(idxs, inParent: supernode, withAnimation: NSTableViewAnimationOptions.EffectNone)
	}
}



@objc
private final class _VariableTreeAgent: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
	weak var owner: VariableTreeView?
	@objc
	private func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	owner!._dataTree.variables.count
		}
		if let node = item as? VariableNode {
			return	node.subvariables.count
		}
		fatalError("Unknown node type.")
	}
	@objc
	private func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		if let node = item as? VariableNode {
			return	node.subvariables.count > 0
		}
		return	false
	}
	@objc
	private func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			return	owner!._dataTree.variables[index]
		}
		if let node = item as? VariableNode {
			return	node.subvariables[index]
		}
		fatalError("Unknown node type.")
	}
	@objc
	private func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		precondition(item is VariableNode)

		let	node	=	item as! VariableNode
		let	view	=	VariableNodeView()
		view.data	=	node.data?.toNodeViewData()
		return	view
	}
	@objc private func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
		if let node = item as? VariableNode {
			assert(node.data != nil)
			owner!.currentValue	=	node.data
		}
		else {
			owner!.currentValue	=	nil

		}
		return	true
	}
}


private extension LLDBValue {
	private func toNodeViewData() -> VariableNodeView.Data {
		return	VariableNodeView.Data(
			name	:	self.name,
			type	:	self.typeName,
			value	:	self.valueExpression ?? "(none)"
		)
	}
}

private extension NSIndexSet {
	convenience init(_ range: Range<Int>) {
		precondition(range.endIndex >= range.startIndex)
		self.init(indexesInRange: NSRange(location: range.startIndex, length: range.count))
	}
}


















private func _instantiateOutlineView() -> NSOutlineView {
	let	c	=	NSTableColumn()
	let	v	=	NSOutlineView()
	v.rowSizeStyle	=	NSTableViewRowSizeStyle.Small		//<	This is REQUIRED. Otherwise, cell icon/text layout won't work.
	v.addTableColumn(c)
	v.outlineTableColumn	=	c
	return	v
}





