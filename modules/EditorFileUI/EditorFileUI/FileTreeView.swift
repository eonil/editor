//
//  FileTreeView.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import MulticastingStorage
import EditorCommon
import EditorModel
import EditorUICommon

public protocol FileTreeViewDelegate: class {
	func fileTreeView(fileTreeView: FileTreeView, didSelectFileNodes: [FileNodeModel])
	func fileTreeView(fileTreeView: FileTreeView, didDeselectFileNodes: [FileNodeModel])
}
public class FileTreeView: CommonView, FileTreeUIProtocol {

	public weak var delegate: FileTreeViewDelegate?

	public var selectedFileNodes: [FileNodeModel] {
		get {
			func fileNodeAtIndex(index: Int) -> FileNodeModel {
				precondition(index != -1)
				return	_outlineView.itemAtRow(index) as! FileNodeModel
			}
			return	_outlineView.selectedRowIndexes.map(fileNodeAtIndex)
		}
	}
	public func isFileNodeDisplayed(fileNode: FileNodeModel) -> Bool {
		let idx = _outlineView.rowForItem(fileNode)
		return idx != -1
	}
	public func selectFileNode(fileNode: FileNodeModel) {
		assert(isFileNodeDisplayed(fileNode))
		let idx = _outlineView.rowForItem(fileNode)
		guard idx != -1 else {
			fatalError("The file node `\(fileNode)` is not on the list right now.")
		}
		_outlineView.selectRowIndexes(NSIndexSet(index: idx), byExtendingSelection: true)
	}
	public func deselectAllFileNodes() {
		_outlineView.deselectAll(self)
	}

	public weak var model: FileTreeModel? {
		willSet {
			assert(window == nil)
		}
	}

	///

	func reloadData() {
		_outlineView.reloadData()
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
	private let	_outlineAgent	=	_OutlineAgent()

//	private var	_subnodeArrayAgentMapping	=	[ObjectIdentifier: _SubnodeArrayAgent]()		//< Key is object identifier of source node.

	private func _install() {
		_outlineAgent.owner		=	self
		_outlineView.setDataSource(_outlineAgent)
		_outlineView.setDelegate(_outlineAgent)
		_scrollView.documentView	=	_outlineView
		addSubview(_scrollView)
		_outlineView.reloadData()

//		_didSetRoot()
		FileNodeModel.Event.Notification.register(ObjectIdentifier(self)) { [weak self] in self?._processNotification($0) }
	}
	private func _deinstall() {
		FileNodeModel.Event.Notification.deregister(ObjectIdentifier(self))
//		_willSetRoot()

		_scrollView.documentView	=	nil
		_scrollView.removeFromSuperview()
		_outlineView.setDelegate(nil)
		_outlineView.setDataSource(nil)
		_outlineAgent.owner		=	nil

		_outlineView.reloadData()
	}
	private func _layout() {
		_scrollView.frame		=	bounds
	}

	private func _processNotification(notification: FileNodeModel.Event.Notification) {
		guard notification.sender.tree === model else {
			return
		}

//		switch notification.event {
//		case .DidInsertSubnode(let arguments):
//			break
//
//		case .WillDeleteSubnode(let arguments):
//
//			break
//		}

		_outlineView.reloadData()
	}

	///

//	private func _onDidChangeTree() {
//		_outlineView.reloadData()
//	}

	///

//	private func _didSetRoot() {
//		if let root = model!.root.value {
//			let	a	=	_SubnodeArrayAgent()
//			a.owner		=	self
//			a.node		=	root
//			root.subnodes.register(a)
//			assert(_subnodeArrayAgentMapping[ObjectIdentifier(root)] == nil)
//			_subnodeArrayAgentMapping[ObjectIdentifier(root)]	=	a
//		}
//		_outlineView.reloadData()
//	}
//	private func _willSetRoot() {
//		if let root = model!.root.value {
//			assert(_subnodeArrayAgentMapping[ObjectIdentifier(root)] != nil)
//			let	a	=	_subnodeArrayAgentMapping[ObjectIdentifier(root)]!
//			_subnodeArrayAgentMapping[ObjectIdentifier(root)]	=	nil
//			root.subnodes.deregister(a)
//			a.node		=	nil
//			a.owner		=	nil
//		}
//		_outlineView.reloadData()
//	}
//
//	private func _didInsertSubnodesInRange(range: Range<Int>, of node: FileNodeModel) {
//		for subnode in node.subnodes.array[range] {
//			let	a	=	_SubnodeArrayAgent()
//			a.owner		=	self
//			a.node		=	subnode
//			subnode.subnodes.register(a)
//			assert(_subnodeArrayAgentMapping[ObjectIdentifier(subnode)] == nil)
//			_subnodeArrayAgentMapping[ObjectIdentifier(subnode)]	=	a
//		}
//		_outlineView.reloadData()
//	}
//	private func _willDeleteSubnodesInRange(range: Range<Int>, of node: FileNodeModel) {
//		for subnode in node.subnodes.array[range] {
//			assert(_subnodeArrayAgentMapping[ObjectIdentifier(subnode)] != nil)
//			let	a	=	_subnodeArrayAgentMapping[ObjectIdentifier(subnode)]!
//			_subnodeArrayAgentMapping[ObjectIdentifier(subnode)]	=	nil
//			subnode.subnodes.deregister(a)
//			a.owner		=	nil
//			a.node		=	nil
//		}
//		_outlineView.reloadData()
//	}

}



private func _instantiateOutlineView() -> NSOutlineView {
	let	c	=	NSTableColumn()
	let	v	=	NSOutlineView()
	v.rowSizeStyle	=	NSTableViewRowSizeStyle.Small		//<	This is REQUIRED. Otherwise, cell icon/text layout won't work.
	v.addTableColumn(c)
	v.outlineTableColumn	=	c
	return	v
}






















private final class _OutlineAgent: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
	weak var owner: FileTreeView?

	@objc
	private func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	owner!.model!.root == nil ? 0 : 1
		}
		else {
			if let item = item as? FileNodeModel {
				return	item.subnodes.count
			}
			else {
				fatalError("Unknown data node.")
			}
		}
	}

	@objc
	private func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		if let item = item as? FileNodeModel {
			return	item.subnodes.count > 0
		}
		else {
			fatalError("Unknown data node.")
		}
	}

	@objc
	private func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			precondition(index == 0)
			return	owner!.model!.root!
		}
		else {
			if let item = item as? FileNodeModel {
				return	item.subnodes[index]
			}
			else {
				fatalError("Unknown data node.")
			}
		}
	}

	@objc
	private func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		func toData(model: FileNodeModel) -> FileNodeView.Data {
			func getName() -> String {
				let path = model.resolvePath()
				if path == WorkspaceItemPath.root {
					return	model.tree.workspace.location.value?.lastPathComponent ?? "(????)"
				}
				else {
					assert(path.parts.last != nil)
					return	path.parts.last ?? ""
				}
			
				return	"(????)"
			}

			let	name	=	getName()
			let	comment	=	model.comment == nil ? "" : " (\(model.comment!))"
			let	text	=	"\(name)\(comment)"
			return	FileNodeView.Data(icon: nil, text: text)
		}

		if let item = item as? FileNodeModel {
			let	v	=	FileNodeView()
			v.data		=	toData(item)
			return	v
		}
		return	nil
	}
}















//
//private final class _SubnodeArrayAgent: ArrayStorageDelegate {
//	weak var owner: FileTreeView?
//	weak var node: FileNodeModel?
//
//	private func willInsertRange(range: Range<Int>) {
//	}
//	private func didInsertRange(range: Range<Int>) {
//		owner!._didInsertSubnodesInRange(range, of: node!)
//	}
//	private func willUpdateRange(range: Range<Int>) {
//		owner!._willDeleteSubnodesInRange(range, of: node!)
//	}
//	private func didUpdateRange(range: Range<Int>) {
//		owner!._didInsertSubnodesInRange(range, of: node!)
//	}
//	private func willDeleteRange(range: Range<Int>) {
//		owner!._willDeleteSubnodesInRange(range, of: node!)
//	}
//	private func didDeleteRange(range: Range<Int>) {
//	}
//}







