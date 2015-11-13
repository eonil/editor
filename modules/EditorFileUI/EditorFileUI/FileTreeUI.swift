//
//  FileTreeUI.swift
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

//public protocol FileTreeUIDelegate: class {
//	func fileTreeView(fileTreeView: FileTreeUI, didSelectFileNodes: [FileNodeModel])
//	func fileTreeView(fileTreeView: FileTreeUI, didDeselectFileNodes: [FileNodeModel])
//}
public class FileTreeUI: CommonView, FileTreeUIProtocol {

//	public weak var delegate: FileTreeUIDelegate?

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


	private func _install() {
		_scrollView.drawsBackground	=	false
		_outlineAgent.owner		=	self
		_outlineView.setDataSource(_outlineAgent)
		_outlineView.setDelegate(_outlineAgent)
		_scrollView.documentView	=	_outlineView
		addSubview(_scrollView)
		_outlineView.reloadData()

		FileNodeModel.Event.Notification.register(ObjectIdentifier(self)) { [weak self] in self?._process($0) }
	}
	private func _deinstall() {
		FileNodeModel.Event.Notification.deregister(ObjectIdentifier(self))

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

	private func _process(notification: FileNodeModel.Event.Notification) {
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
}


























private final class _OutlineAgent: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
	weak var owner: FileTreeUI?

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
					return	model.tree.workspace.location?.lastPathComponent ?? "(????)"
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





//	@objc
//	private func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
//
//	}

	@objc
	private func outlineViewSelectionDidChange(notification: NSNotification) {
		func getSelectedItem() -> FileNodeModel? {
			let	ridx	=	owner!._outlineView.selectedRow
			guard ridx != NSNotFound else {
				return	nil
			}
			guard let item = owner!._outlineView.itemAtRow(ridx) as? FileNodeModel else {
				return	nil
			}
			return	item
		}
		if let item = getSelectedItem() {
			UIState.ForWorkspaceModel.set(owner!.model!.workspace) {
				$0.editingSelection	=	item.resolvePath().absoluteFileURL(`for`: owner!.model!.workspace)
				()
			}
		}
		else {
			UIState.ForWorkspaceModel.set(owner!.model!.workspace) {
				$0.editingSelection	=	nil
				()
			}
		}
	}
}





















private func _instantiateOutlineView() -> NSOutlineView {
	return	CommonViewFactory.instantiateOutlineViewForUseInSidebar()
}







