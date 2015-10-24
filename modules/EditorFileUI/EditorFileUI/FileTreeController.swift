////
////  FileTreeView.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/08/29.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import MulticastingStorage
//import EditorCommon
//import EditorModel
//import EditorUICommon
//
//public class FileTreeController: CommonViewController {
//
//	public weak var model: FileTreeModel? {
//		willSet {
//			assert(view.window == nil)
//		}
//	}
//
//	///
//
//	func reloadData() {
//		_outlineView.reloadData()
//	}
//
//	///
//
//	public override func installSubcomponents() {
//		super.installSubcomponents()
//		_install()
//	}
//	public override func deinstallSubcomponents() {
//		_deinstall()
//		super.deinstallSubcomponents()
//	}
//	public override func layoutSubcomponents() {
//		super.layoutSubcomponents()
//		_layout()
//	}
//
//	///
//
//	private let	_scrollView	=	NSScrollView()
//	private let	_outlineView	=	_instantiateOutlineView()
//	private let	_outlineAgent	=	_OutlineAgent()
//
//	private var	_subnodeArrayAgentMapping	=	[ObjectIdentifier: _SubnodeArrayAgent]()		//< Key is object identifier of source node.
//
//	private func _install() {
//		_outlineAgent.owner		=	self
//		_outlineView.setDataSource(_outlineAgent)
//		_outlineView.setDelegate(_outlineAgent)
//		_scrollView.documentView	=	_outlineView
//		view.addSubview(_scrollView)
//		_outlineView.reloadData()
//
//		_didSetRoot()
//		model!.root.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//			self?._didSetRoot()
//		}
//		model!.root.registerWillSet(ObjectIdentifier(self)) { [weak self] in
//			self?._willSetRoot()
//		}
//
//		model!.onDidChange.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//			guard self != nil else {
//				return
//			}
//			self!._onDidChangeTree()
//		}
//	}
//	private func _deinstall() {
//		model!.onDidChange.deregisterDidSet(ObjectIdentifier(self))
//		model!.root.deregisterWillSet(ObjectIdentifier(self))
//		model!.root.deregisterDidSet(ObjectIdentifier(self))
//		_willSetRoot()
//
//		_scrollView.documentView	=	nil
//		_scrollView.removeFromSuperview()
//		_outlineView.setDelegate(nil)
//		_outlineView.setDataSource(nil)
//		_outlineAgent.owner		=	nil
//
//		_outlineView.reloadData()
//	}
//	private func _layout() {
//		_scrollView.frame		=	view.bounds
//	}
//
//	///
//
//	private func _onDidChangeTree() {
//		_outlineView.reloadData()
//	}
//
//	///
//
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
//
//}
//
//
//
//private func _instantiateOutlineView() -> NSOutlineView {
//	let	c	=	NSTableColumn()
//	let	v	=	NSOutlineView()
//	v.rowSizeStyle	=	NSTableViewRowSizeStyle.Small		//<	This is REQUIRED. Otherwise, cell icon/text layout won't work.
//	v.addTableColumn(c)
//	v.outlineTableColumn	=	c
//	return	v
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//private final class _OutlineAgent: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
//	weak var owner: FileTreeController?
//
//	@objc
//	private func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
//		if item == nil {
//			return	owner!.model!.root.value == nil ? 0 : 1
//		}
//		else {
//			if let item = item as? FileNodeModel {
//				return	item.subnodes.array.count
//			}
//			else {
//				fatalError("Unknown data node.")
//			}
//		}
//	}
//
//	@objc
//	private func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
//		if let item = item as? FileNodeModel {
//			return	item.subnodes.array.count > 0
//		}
//		else {
//			fatalError("Unknown data node.")
//		}
//	}
//
//	@objc
//	private func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
//		if item == nil {
//			precondition(index == 0)
//			return	owner!.model!.root.value!
//		}
//		else {
//			if let item = item as? FileNodeModel {
//				return	item.subnodes.array[index]
//			}
//			else {
//				fatalError("Unknown data node.")
//			}
//		}
//	}
//
//	@objc
//	private func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
//		func toData(model: FileNodeModel) -> FileNodeView.Data {
//			func getName() -> String {
//				if let path = model.path.value {
//					if path == WorkspaceItemPath.root {
//						return	model.tree.workspace.location.value?.lastPathComponent ?? "(????)"
//					}
//					else {
//						assert(path.parts.last != nil)
//						return	path.parts.last ?? ""
//					}
//				}
//				return	"(????)"
//			}
//
//			let	name	=	getName()
//			let	comment	=	model.comment.value == nil ? "" : " (\(model.comment.value!))"
//			let	text	=	"\(name)\(comment)"
//			return	FileNodeView.Data(icon: nil, text: text)
//		}
//
//		if let item = item as? FileNodeModel {
//			let	v	=	FileNodeView()
//			v.data		=	toData(item)
//			return	v
//		}
//		return	nil
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
//
//
//
//
//
//
//
//
//private final class _SubnodeArrayAgent: ArrayStorageDelegate {
//	weak var owner: FileTreeController?
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
//
//
//
//
//
//
//
