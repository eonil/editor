//
//  ContextTreeView.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/28.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import MulticastingStorage

public class ContextTreeView: NSView {
	public weak var model: ExecutionStateInspectionModel? {
		willSet {

		}
		didSet {

		}
	}

	///

	private let	_outlineV	=	NSOutlineView()

	private func _didSetDefaultProcess() {
//		if let process = model!.defaultProcess.value {
//			if model!.defaultProcess.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//				self?._didSet
//			}
//		}
	}
	private func _willSetDefaultProcess() {

	}

	private func _didSetDefaultThread() {

	}
	private func _willSetDefaultThread() {

	}

	private func _didSetDefaultFrame() {

	}
	private func _willSetDefaultFrame() {

	}
}











private final class _OutlineAgent: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
	weak var owner: ContextTreeView?
	@objc
	private func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	owner!.model!.processes.array.count
		}
		else {
			switch item {
			case is ProcessNode:
				return	(item as! ProcessNode).threads.array.count
			case is ThreadNode:
				return	(item as! ThreadNode).frames.array.count
			case is FrameNode:
				fatalError("`FrameNode` does not have any child.")
			case is VariableNode:
				fatalError("`FrameNode` does not have any child.")
			default:
				fatalError("Unknown type of node.")
			}
		}
	}
	@objc
	private func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			return	owner!.model!.processes.array[index]
		}
		else {
			switch item {
			case is ProcessNode:
				return	(item as! ProcessNode).threads.array[index]
			case is ThreadNode:
				return	(item as! ThreadNode).frames.array[index]
			case is FrameNode:
				fatalError("`FrameNode` does not have any child.")
			case is VariableNode:
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
}
















