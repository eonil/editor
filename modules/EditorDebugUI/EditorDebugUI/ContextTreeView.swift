//
//  ContextTreeView.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/28.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import LLDBWrapper
import MulticastingStorage
import EditorCommon
import EditorUICommon

public class ContextTreeView: CommonView {

//	public var onUserDidSelectProcess	:	(()->())?
//	public var onUserWillDeselectProcess	:	(()->())?
//
//	public var onUserDidSelectThread	:	(()->())?
//	public var onUserWillDeselectThread	:	(()->())?

	public var onUserDidSetFrame		:	(()->())?
	public var onUserWillSetFrame		:	(()->())?









	///

	public func reconfigure(debugger: LLDBDebugger?) {
		_dataTree.reconfigure(debugger)
		_outlineV.reloadData()

		// Select first frame of current thread.
		if let f = currentFrame {
			if let n = _dataTree.nodeForThread(f.thread) {
				if let firstFrameNode = n.frames.first {
					let	idx	=	_outlineV.rowForItem(firstFrameNode)
					if idx != NSNotFound {
						_outlineV.selectRowIndexes(NSIndexSet(index: idx), byExtendingSelection: false)
						_outlineV.selectedRow

						if currentFrame?.frameID != firstFrameNode.data?.frameID {
							currentFrame	=	firstFrameNode.data
						}
					}
				}
			}
		}
	}

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


	public override var acceptsFirstResponder: Bool {
		get {
			return	_outlineV.acceptsFirstResponder
		}
	}
	public override func becomeFirstResponder() -> Bool {
		return	window!.makeFirstResponder(_outlineV)
	}









//	public private(set) var currentProcess: LLDBProcess? {
//		didSet {
//			if currentProcess != nil {
//				onUserDidSelectProcess?()
//			}
//		}
//		willSet {
//			if currentProcess != nil {
//				onUserWillDeselectProcess?()
//			}
//		}
//	}
//	public private(set) var currentThread: LLDBThread? {
//		didSet {
//			if currentThread != nil {
//				onUserDidSelectThread?()
//			}
//		}
//		willSet {
//			if currentThread != nil {
//				onUserWillDeselectThread?()
//			}
//		}
//	}
	public private(set) var currentFrame: LLDBFrame? {
		willSet {
			onUserWillSetFrame?()
		}
		didSet {
			onUserDidSetFrame?()
		}
	}

	///

	private let	_scrollV	=	_instantiateScrollView()
	private let	_outlineV	=	_instantiateOutlineView()
	private let	_outlineA	=	_OutlineAgent()
	private let	_dataTree	=	ContextTree()

	private func _install() {
		_outlineA.owner		=	self
		_outlineV.setDataSource(_outlineA)
		_outlineV.setDelegate(_outlineA)

		_scrollV.documentView		=	_outlineV
		addSubview(_scrollV)

		_outlineV.reloadData()
	}
	private func _deinstall() {
		_scrollV.removeFromSuperview()
		_scrollV.documentView	=	nil

		_outlineV.setDataSource(nil)
		_outlineV.setDelegate(nil)
		_outlineA.owner		=	nil
	}
	private func _layout() {
		_scrollV.frame		=	bounds
	}
}






















































private final class _OutlineAgent: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
	weak var owner: ContextTreeView?
	@objc
	private func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	owner!._dataTree.processes.count
		}
		else {
			switch item {
			case is ProcessNode:
				return	(item as! ProcessNode).threads.count
			case is ThreadNode:
				return	(item as! ThreadNode).frames.count
			case is FrameNode:
				fatalError("`FrameNode` does not have any child.")
			default:
				fatalError("Unknown type of node.")
			}
		}
	}
	@objc
	private func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		switch item {
		case is ProcessNode:
			return	(item as! ProcessNode).threads.count > 0
		case is ThreadNode:
			return	(item as! ThreadNode).frames.count > 0
		case is FrameNode:
			return	false
		default:
			fatalError("Unknown type of node.")
		}
	}
	@objc
	private func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			return	owner!._dataTree.processes[index]
		}
		else {
			switch item {
			case is ProcessNode:
				return	(item as! ProcessNode).threads[index]
			case is ThreadNode:
				return	(item as! ThreadNode).frames[index]
			case is FrameNode:
				fatalError("`FrameNode` does not have any child.")
			default:
				fatalError("Unknown type of node.")
			}
		}
	}
	@objc
	private func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		switch item {
		case is ProcessNode:
			let	process		=	(item as! ProcessNode)
			let	view		=	ProcessNodeView()
			view.model		=	process
			return	view

		case is ThreadNode:
			let	thread		=	(item as! ThreadNode)
			let	view		=	ThreadNodeView()
			view.model		=	thread
			return	view

		case is FrameNode:
			let	frame		=	(item as! FrameNode)
			let	view		=	FrameNodeView()
			view.model		=	frame
			return	view

		default:
			fatalError("Unknown type of node.")
		}
	}

	@objc
	private func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
		switch item {
		case is ProcessNode:
			break

		case is ThreadNode:
			break

		case is FrameNode:
			let	frame		=	(item as! FrameNode)
			assert(frame.data != nil)
			if let data = frame.data {
				assert(frame.data != nil)
				owner!.currentFrame	=	data
			}
			else {
				owner!.currentFrame	=	nil
			}

		default:
			fatalError("Unknown type of node.")
		}
		
		return	true
	}

}




























private func _instantiateScrollView() -> NSScrollView {
	let	v	=	NSScrollView()
	v.drawsBackground	=	false
	return	v
}

private func _instantiateOutlineView() -> NSOutlineView {
	return	CommonViewFactory.instantiateOutlineViewForUseInSidebar()
}




