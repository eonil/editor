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

//	public var selectedFileNodes: [FileNodeModel] {
//		get {
//			func fileNodeAtIndex(index: Int) -> FileNodeModel {
//				precondition(index != -1)
//				return	_outlineView.itemAtRow(index) as! FileNodeModel
//			}
//			return	_outlineView.selectedRowIndexes.map(fileNodeAtIndex)
//		}
//	}
//	public func isFileNodeDisplayed(fileNode: FileNodeModel) -> Bool {
//		let idx = _outlineView.rowForItem(fileNode)
//		return idx != -1
//	}
//	public func selectFileNode(fileNode: FileNodeModel) {
//		assert(isFileNodeDisplayed(fileNode))
//		let idx = _outlineView.rowForItem(fileNode)
//		guard idx != -1 else {
//			fatalError("The file node `\(fileNode)` is not on the list right now.")
//		}
//		_outlineView.selectRowIndexes(NSIndexSet(index: idx), byExtendingSelection: true)
//	}
//	public func deselectAllFileNodes() {
//		_outlineView.deselectAll(self)
//	}

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
		FileNodeModel.Event.Notification.register	(ObjectIdentifier(self)) { [weak self] in self?._process($0) }
	}
	private func _deinstall() {
		FileNodeModel.Event.Notification.deregister(ObjectIdentifier(self))
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
		func getSelectedItem() -> FileNodeModel? {
			let	ridx	=	_outlineView.selectedRow
			guard ridx != NSNotFound else {
				return	nil
			}
			guard let item = _outlineView.itemAtRow(ridx) as? FileNodeModel else {
				return	nil
			}
			return	item
		}
		func getSustaningItemSelectionList() -> [FileNodeModel] {
			func convert(rowIndex: Int) -> FileNodeModel {
				return	_outlineView.itemAtRow(rowIndex) as! FileNodeModel
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
				func convert(rowIndex: Int) -> FileNodeModel {
					return	self!._outlineView.itemAtRow(rowIndex) as! FileNodeModel
				}
				return	self!._outlineView.selectedRowIndexes.map(convert)
			}()
			()
		}
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
	private func _process(n: FileTreeModel.Event.Notification) {
		guard n.sender === model else {
			return
		}

		_outlineView.reloadData()
	}









	///

	private func _getClickedFileNode() -> FileNodeModel? {
		let	rowIndex	=	_outlineView.clickedRow
		guard rowIndex != -1 else {
			return	nil
		}
		guard let n = _outlineView.itemAtRow(rowIndex) as? FileNodeModel else {
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
			
//				return	"(????)"
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









	@objc
	private func outlineView(outlineView: NSOutlineView, shouldTrackCell cell: NSCell, forTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> Bool {
		return	true
	}

//	@objc
//	private func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
//
//	}

	@objc
	private func outlineViewSelectionDidChange(notification: NSNotification) {
		owner!._didChangeSelection()
	}













	///
	@objc
	private func outlineView(outlineView: NSOutlineView, writeItems items: [AnyObject], toPasteboard pasteboard: NSPasteboard) -> Bool {
		func toPath(n: FileNodeModel) -> String {
			return	n.resolvePath().absoluteFileURL(`for`: owner!.model!.workspace).path!
		}
		let	ss	=	(items as? [FileNodeModel] ?? []).map(toPath)
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
		guard let item = item as? FileNodeModel else {
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







