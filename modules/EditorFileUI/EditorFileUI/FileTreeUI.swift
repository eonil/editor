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

public class FileTreeUI: CommonView {


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

	public override var acceptsFirstResponder: Bool {
		get {
			return	_outlineView.acceptsFirstResponder
		}
	}
	public override func becomeFirstResponder() -> Bool {
		return	window!.makeFirstResponder(_outlineView)
	}












	///

	@objc
	private func EDITOR_onDoubleClick(_: AnyObject?) {
		// Do nothing.
		return
	}










	///

	private let	_scrollView	=	NSScrollView()
	private let	_outlineView	=	_instantiateOutlineView()
	private let	_outlineAgent	=	_OutlineAgent()

	private let	_menuController	=	FileTreeUIMenuController()







	///

	private func _install() {
		_scrollView.drawsBackground	=	false
		_outlineAgent.owner		=	self
		_outlineView.menu		=	_menuController.menu		// Actually menu is designated by `menuForEvent`, but we need to set this to show a focus ring on a cell on right mouse down.
		_outlineView.setDataSource(_outlineAgent)
		_outlineView.setDelegate(_outlineAgent)
		_outlineView.target		=	self
		_outlineView.doubleAction	=	"EDITOR_onDoubleClick:"
		_scrollView.documentView	=	_outlineView
		addSubview(_scrollView)
		_outlineView.reloadData()
		_menuController.model		=	model
		_menuController.getClickedFileNode	=	{ [weak self] in self?._getClickedFileNode() }

		_outlineView.registerForDraggedTypes([NSFilenamesPboardType])
		FileTreeModel.Event.Notification.register	(self, FileTreeUI._process)
	}
	private func _deinstall() {
		FileTreeModel.Event.Notification.deregister	(self)
		_outlineView.unregisterDraggedTypes()

		_menuController.getClickedFileNode	=	nil
		_menuController.model		=	nil
		_scrollView.documentView	=	nil
		_scrollView.removeFromSuperview()
		_outlineView.action		=	nil
		_outlineView.doubleAction	=	nil
		_outlineView.setDelegate(nil)
		_outlineView.setDataSource(nil)
		_outlineView.menu		=	nil
		_outlineAgent.owner		=	nil

		_outlineView.reloadData()
	}
	private func _layout() {
		_scrollView.frame		=	bounds
	}





	private func _didChangeSelection() {
		func getSelectedItem() -> WorkspaceItemNode? {
			let	ridx	=	_outlineView.selectedRow
			guard ridx != NSNotFound else {
				return	nil
			}
			guard let item = _outlineView.itemAtRow(ridx) as? WorkspaceItemNode else {
				return	nil
			}
			return	item
		}
		func getSustaningItemSelectionList() -> [WorkspaceItemNode] {
			func convert(rowIndex: Int) -> WorkspaceItemNode {
				return	_outlineView.itemAtRow(rowIndex) as! WorkspaceItemNode
			}
			return	_outlineView.selectedRowIndexes.map(convert)
		}

		///

		if let item = getSelectedItem() {
			UIState.ForWorkspaceModel.set(model!.workspace) {
				$0.editingSelection	=	item.resolvePath().absoluteFileURL(`for`: model!.workspace)
				()
			}
		}
		else {
			UIState.ForWorkspaceModel.set(model!.workspace) {
				$0.editingSelection	=	nil
				()
			}
		}



		UIState.ForFileTreeModel.set(model!) {
			$0.sustainingFileSelection	=	{ [weak self] in
				guard self != nil else {
					return	[]
				}
				func convert(rowIndex: Int) -> WorkspaceItemNode {
					return	self!._outlineView.itemAtRow(rowIndex) as! WorkspaceItemNode
				}
				return	self!._outlineView.selectedRowIndexes.map(convert)
			}()
			()
		}
	}







	private func _process(n: FileTreeModel.Event.Notification) {
		guard n.sender === model else {
			return
		}

		_outlineView.reloadData()
	}









	///

	private func _getClickedFileNode() -> WorkspaceItemNode? {
		let	rowIndex	=	_outlineView.clickedRow
		guard rowIndex != -1 else {
			return	nil
		}
		guard let n = _outlineView.itemAtRow(rowIndex) as? WorkspaceItemNode else {
			return	nil
		}

		return	n
	}
}


























private final class _OutlineAgent: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
	weak var owner: FileTreeUI?

	@objc
	private func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	owner!.model!.tree == nil ? 0 : 1
		}
		else {
			if let item = item as? WorkspaceItemNode {
				return	item.subnodes.count
			}
			else {
				fatalError("Unknown data node.")
			}
		}
	}

	@objc
	private func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		if let item = item as? WorkspaceItemNode {
			return	item.isGroup
		}
		else {
			fatalError("Unknown data node.")
		}
	}

	@objc
	private func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			precondition(index == 0)
			return	owner!.model!.tree!.root!
		}
		else {
			if let item = item as? WorkspaceItemNode {
				return	item.subnodes[index]
			}
			else {
				fatalError("Unknown data node.")
			}
		}
	}

	@objc
	private func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		func toData(node: WorkspaceItemNode) -> FileNodeView.Data {
			func getName() -> String {
				let path = node.resolvePath()
				if path == WorkspaceItemPath.root {
					return	owner!.model!.workspace.location?.lastPathComponent ?? "(????)"
				}
				else {
					assert(path.parts.last != nil)
					return	path.parts.last ?? ""
				}
			
//				return	"(????)"
			}

			let	name	=	getName()
			let	comment	=	node.comment == nil ? "" : " (\(node.comment!))"
			let	text	=	"\(name)\(comment)"
			return	FileNodeView.Data(icon: nil, text: text)
		}

		if let item = item as? WorkspaceItemNode {
			let	v	=	FileNodeView()
			v.data		=	toData(item)
			return	v
		}
		return	nil
	}









	@objc
	private func outlineView(outlineView: NSOutlineView, shouldTrackCell cell: NSCell, forTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> Bool {
		return	true
	}

	@objc
	private func outlineViewSelectionDidChange(notification: NSNotification) {
		owner!._didChangeSelection()
	}













	///
	@objc
	private func outlineView(outlineView: NSOutlineView, writeItems items: [AnyObject], toPasteboard pasteboard: NSPasteboard) -> Bool {
		func toPath(n: WorkspaceItemNode) -> String {
			return	n.resolvePath().absoluteFileURL(`for`: owner!.model!.workspace).path!
		}
		let	ss	=	(items as? [WorkspaceItemNode] ?? []).map(toPath)
		pasteboard.declareTypes([NSFilenamesPboardType], owner: self)
		pasteboard.setPropertyList(ss, forType: NSFilenamesPboardType)
		return	true
	}


	///

	@objc
	private func outlineView(outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: AnyObject?, proposedChildIndex index: Int) -> NSDragOperation {
		return	NSDragOperation.Copy
	}
	@objc
	private func outlineView(outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: AnyObject?, childIndex index: Int) -> Bool {
		guard let item = item as? WorkspaceItemNode else {
			return	false
		}
		guard item.isGroup else {
			fatalError("Non-group node shouldn't be a dropping target.")
		}

		let	pb	=	info.draggingPasteboard()
		let	files	=	pb.propertyListForType(NSFilenamesPboardType)

		guard let filePaths = files as? NSArray as? [String] else {
			fatalError("Non-path file dropping is not supported.")
			return	false
		}

//		var subnodes	=	[FileNodeModel]()
//		for fileURL in fileURLs {
//			guard let filePath = fileURL.path else {
//				break
//			}
//			guard let fileName = fileURL.lastPathComponent else {
//				break
//			}
//			var	isDir	=	false as ObjCBool
//			let	ok	=	NSFileManager.defaultManager().fileExistsAtPath(filePath, isDirectory: &isDir)
//			guard ok else {
//				break
//			}
//			let	n	=	FileNodeModel(name: fileName, isGroup: false)
//			subnodes.append(n)
//		}
//
////		// Transactional commit.
////		for i in 0..<subnodes.count {
////			try? item.subnodes.insert(subnodes[i], at: index + i)
////		}
		return	false
	}
}





















private func _instantiateOutlineView() -> NSOutlineView {
	return	CommonViewFactory.instantiateOutlineViewForUseInSidebar()
}







