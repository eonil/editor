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

public class VariableTreeView: NSView {
	public weak var model: FrameNode? {
		willSet {
			_outlineView.reloadData()
			_outlineView.setDataSource(nil)
			_outlineView.setDelegate(nil)
		}
		didSet {
			_outlineView.setDataSource(_outlineAgent)
			_outlineView.setDelegate(_outlineAgent)
			_outlineView.reloadData()
		}
	}

	///

	private let	_outlineView	=	NSOutlineView()
	private let	_outlineAgent	=	_VariableTreeAgent()

	private func _install() {
		addSubview(_outlineView)
	}
	private func _deinstall() {
		_outlineView.removeFromSuperview()
	}
	private func _layout() {
		_outlineView.frame	=	bounds
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
			return	owner!.model!.variables.array.count
		}
		if let node = item as? VariableNode {
			return	node.subvariables.array.count
		}
		fatalError("Unknown node type.")
	}
	@objc
	private func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			return	owner!.model!.variables.array[index]
		}
		if let node = item as? VariableNode {
			return	node.subvariables.array[index]
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
}


private extension LLDBValue {
	private func toNodeViewData() -> VariableNodeView.Data {
		return	VariableNodeView.Data(
			name	:	self.name,
			type	:	self.typeName,
			value	:	self.valueExpression
		)
	}
}

private extension NSIndexSet {
	convenience init(_ range: Range<Int>) {
		precondition(range.endIndex >= range.startIndex)
		self.init(indexesInRange: NSRange(location: range.startIndex, length: range.count))
	}
}







