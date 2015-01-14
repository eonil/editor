//
//  FileTreeViewController4.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilDispatch
import Precompilation




public protocol FileTreeViewController4Delegate: class {
//	func fileTreeViewController4IsNotifyingAddingNodeAtURL(NSURL)
//	func fileTreeViewController4IsNotifyingRemovingNodeAtURL(NSURL)
//	func fileTreeViewController4IsNotifyingRelocatingNodeAtURL(NSURL)
	
	func fileTreeViewController4IsNotifyingUserWantsToEditFileAtURL(NSURL)
	func fileTreeViewController4IsNotifyingKillingRootURL()
}


///
///
///	Take care that the file-system monitoring can be suspended by request,
///	and this class is using it to suspend file-system monitoring events
///	while column editing.
public class FileTreeViewController4 : NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate, NSTextFieldDelegate, FileTableCellEditingDelegate {
	public weak var delegate:FileTreeViewController4Delegate?
	
//	/	Directories are excluded.
//	let	userIsWantingToEditFileAtURL	=	Notifier<NSURL>()
	
	private	var	_fileTreeRepository		=	nil as FileTreeRepository4?
	private	var	_fileSystemMonitor		=	nil as FileSystemMonitor3?
	
	private let	_contextMenuManager		=	ContextMenuManager()

	
	
	
	///	Gets and sets URL for root node.
	public var URLRepresentation:NSURL? {
		get {
			return	self.representedObject as NSURL?
		}
		set(v) {
			self.representedObject	=	v
		}
	}
	
	///	Notifies invlidation of a node.
	///	The UI will be updated to reflect the invalidation.
	public func invalidateNodeForURL(u:NSURL) {
		Debug.assertMainThread()
		assert(_fileTreeRepository != nil)
		Debug.log("invalidateNodeForURL: \(u)")
		
		if u == URLRepresentation {
			self.delegate?.fileTreeViewController4IsNotifyingKillingRootURL()
			self.URLRepresentation	=	nil		//	Self-destruction.
			self.outlineView.reloadData()
			return
		}
		
		let	u2	=	u.URLByDeletingLastPathComponent!
		
		//	File-system notifications are sent asynchronously, 
		//	then a file-node for the URL may not exist.
		if let n1 = _fileTreeRepository![u2] {
			reloadNode(n1)
		}
	}
	
	///	Designed to minimise actual refreshing of UI element.
	private func reloadNode(invalidationRootNode:FileNode4) {
		Debug.assertMainThread()
		
		outlineView.beginUpdates()
		
		let	oldURLs		=	invalidationRootNode.subnodes.links
		let	newURLs		=	subnodeAbsoluteURLsOfURL(invalidationRootNode.link)
		let	deltaset	=	resolveDifferences(oldURLs, newURLs)
		
		let	outgoingRows	=	deltaset.outgoings.map { [unowned self] (u:NSURL)->Int in
			let	n	=	self._fileTreeRepository![u]
			let	row	=	find(oldURLs, u)
			assert(n != nil)
			assert(row != nil)
			return	row!
		}
		if outgoingRows.count > 0 {
			outlineView.removeItemsAtIndexes(NSIndexSet(outgoingRows), inParent: invalidationRootNode, withAnimation: NSTableViewAnimationOptions.allZeros)
//			Debug.log("reloadNode/removeItemsAtIndexes: \(outgoingRows), parent: \(invalidationRootNode)")
		}
		
		////	BEFORE reloading database.
		
		//	Here we update underlying database. And UI refresh will be affected by this.
		//	So you shouldn mix code before this and after this. They must be separated in order.
		let	newsubnodeURLs	=	deltaset.stays + deltaset.incomings
		invalidationRootNode.subnodes.links	=	newsubnodeURLs
		
		////	AFTER reloading database.
		
		let	incomingRows	=	deltaset.incomings.map { [unowned self] (u:NSURL)->Int in
			let	n	=	self._fileTreeRepository![u]
			let	row	=	find(newsubnodeURLs, u)
			assert(n != nil)
			assert(row != nil)
			return	row!
		}
		if incomingRows.count > 0 {
			outlineView.insertItemsAtIndexes(NSIndexSet(incomingRows), inParent: invalidationRootNode, withAnimation: NSTableViewAnimationOptions.allZeros)
//			Debug.log("reloadNode/insertItemsAtIndexes: \(incomingRows), parent: \(invalidationRootNode)")
		}
		
		outlineView.endUpdates()
	}
	
	///	No-op if a node for the supplied URL does not exists.
	func editNodeForURL(targetNodeURL:NSURL) {
		let	n1	=	_fileTreeRepository![targetNodeURL]		//	Can be `nil` if the newly created directory has been deleted immediately. This is very unlikely to happen, but possible in theory.
		if let targetNode = n1 {
			let	idx		=	self.outlineView.rowForItem(targetNode)			//	Now it should have a node for the URL.
			assert(idx >= 0)
			if idx >= 0 {
				self.outlineView.editColumn(0, row: idx, withEvent: nil, select: true)
			} else {
				//	Shouldn't happen, but nobody knows...
			}
		}
	}
	
	
	
	
	
	
	
	public override var representedObject:AnyObject? {
		willSet(v) {
			precondition(v == nil || v is NSURL)
			
			_fileSystemMonitor	=	nil
			_fileTreeRepository	=	nil
		}
		didSet {
			assert(URLRepresentation == nil || URLRepresentation?.existingAsDirectoryFile == true)
			
			if let v3 = URLRepresentation {
				_fileTreeRepository	=	FileTreeRepository4(rootlink: v3)
				_fileTreeRepository!.reload()
				
				let	callback	=	{ [weak self] (u:NSURL)->() in
					self?.invalidateNodeForURL(u)
					return	()
				}
				_fileSystemMonitor	=	FileSystemMonitor3(monitoringRootURL: v3, callback: callback)
			}
			self.outlineView.reloadData()
			if URLRepresentation != nil {
				self.outlineView.expandItem(_fileTreeRepository!.root, expandChildren: false)
			}
		}
	}
	
	public var outlineView:NSOutlineView {
		get {
			return	self.view as NSOutlineView
		}
		set(v) {
			self.view	=	v
		}
	}
	public override func loadView() {
		super.view	=	NSOutlineView()
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		let	NAME_ID	=	"NAME"
		let	col1	=	NSTableColumn(identifier: NAME_ID)
		col1.title	=	"Name"
		col1.width	=	100

		outlineView.addTableColumn(col1)
		outlineView.outlineTableColumn		=	col1
		outlineView.rowSizeStyle			=	NSTableViewRowSizeStyle.Small
		outlineView.selectionHighlightStyle	=	NSTableViewSelectionHighlightStyle.SourceList
		outlineView.allowsMultipleSelection	=	true
		outlineView.focusRingType			=	NSFocusRingType.None
		outlineView.headerView				=	nil
		outlineView.doubleAction			=	"dummyDoubleAction:"		//	This is required to make column editing to be started with small delay like renaming in Finder.
		
		outlineView.sizeLastColumnToFit()
		
		outlineView.setDataSource(self)
		outlineView.setDelegate(self)
		
		_contextMenuManager.owner	=	self
		outlineView.menu			=	_contextMenuManager.menu
	}
	
	
	
	
	
	
	
	
	@objc
	func dummyDoubleAction(AnyObject?) {
		println("AA")
	}
	
//	func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
//		return	16
//	}
	
	public func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		let	n1	=	item as FileNode4?
		if let n2 = n1 {
			if n2.subnodes.count == 0 {
				n2.reloadSubnodes()
			}
			return	n2.subnodes.count
		} else {
			return	_fileTreeRepository?.root == nil ? 0 : 1
		}
	}
	public func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		let	n1	=	item as FileNode4?
		if let n2 = n1 {
			return	n2.subnodes[index]
		} else {
			return	_fileTreeRepository!.root!
		}
	}
	
//	func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
//		let	n1	=	item as FileNode4
//		let	ns2	=	n1.subnodes
//		return	ns2 != nil
//	}
	
	public func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		let	n1	=	item as FileNode4
		return	n1.directory
	}
	
//	public func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
//		return
//	}

//	public func outlineView(outlineView: NSOutlineView, rowViewForItem item: AnyObject) -> NSTableRowView? {
//		return	FileTreeTableRowView()
//	}
	public func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		let	cv1	=	FileTableCellView()
		cv1.editingDelegate				=	self

		///	Do not query on file-system here.
		///	The node is a local cache, and may not exist on 
		///	underlying file-system. 
		///	This is especially true for kqueue/GCD notification.
		///	GCD VNODE notifications are fired asynchronously, and
		///	the actual file can be already gone at the time of the
		///	notification arrives. In other words, file operation
		///	does not wait for notification returns.
		///	So do not query on file-system at this point, and just
		///	use cached data on the node.
		
		let	n1	=	item as FileNode4
		cv1.imageView!.image			=	n1.icon
		cv1.textField!.stringValue		=	n1.displayName
		cv1.textField!.bordered			=	false
		cv1.textField!.backgroundColor	=	NSColor.clearColor()
		cv1.textField!.delegate			=	self
		
		(cv1.textField!.cell() as NSCell).lineBreakMode	=	NSLineBreakMode.ByTruncatingTail
		cv1.objectValue					=	n1
		return	cv1
	}
	
	
	
	
	
	
	public func outlineViewSelectionDidChange(notification: NSNotification) {
		let	idx1	=	self.outlineView.selectedRow
		if idx1 >= 0 {	
			let	n1		=	self.outlineView.itemAtRow(idx1) as FileNode4
			delegate?.fileTreeViewController4IsNotifyingUserWantsToEditFileAtURL(n1.link)
		}
	}
	public func outlineViewItemDidCollapse(notification: NSNotification) {
		assert(notification.name == NSOutlineViewItemDidCollapseNotification)
		let	n1	=	notification.userInfo!["NSObject"]! as FileNode4
		n1.resetSubnodes()
	}
	
	
	internal func fileTableCellDidBecomeFirstResponder() {
		println(outlineView.editedRow)
	}
	internal func fileTableCellDidResignFirstResponder() {
		println(outlineView.editedRow)
		
	}
	internal func fileTableCellDidCancelEditing() {
		outlineView.window!.makeFirstResponder(outlineView)
	}
	
	public func control(control: NSControl, isValidObject obj: AnyObject) -> Bool {
		println(obj)
		return	true
	}
	public override func controlTextDidEndEditing(obj: NSNotification) {
		let	tf	=	obj.object as FileTableCellTextField!
		let	c	=	tf.superview as FileTableCellView!
		let	n	=	c.objectValue as FileNode4!
		
		let	u	=	n.link
		let	u1	=	n.link.URLByDeletingLastPathComponent!
		let	u2	=	u1.URLByAppendingPathComponent(tf.stringValue, isDirectory: u.existingAsDirectoryFile)
		
		if u != u2 {
			//	Relocate the node instance to avoid recreation when reloading by file-monitoring.
			n.link	=	u2
			
			var	e	=	nil as NSError?
			let	ok	=	NSFileManager.defaultManager().moveItemAtURL(u, toURL: u2, error: &e)
			if !ok {
				presentError(e!)
			}
		} else {
			//	Name unchanged.
		}
	}
//	func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
//		if _fileSystemMonitor!.isPending == false {
//			_fileSystemMonitor!.suspendEventCallbackDispatch()
//		}
//		return	true
//	}
//	func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
//		return	true
//	}
//	override func controlTextDidEndEditing(obj: NSNotification) {
//		Debug.log("controlTextDidEndEditing")
//		
//		if _fileSystemMonitor!.isPending {
//			_fileSystemMonitor!.resumeEventCallbackDispatch()	//	This will trigger sending of pended events, and effectively reloading of some nodes.
//		}
//	}
}

//@objc
//class FileTableRowView: NSTableRowView {
//	@objc
//	var objectValue:AnyObject? {
//		get {
//			return	"AAA"
//		}
//		set(v) {
//			
//		}
//	}
//}
















































@objc
private final class ContextMenuManager : NSObject, NSMenuDelegate {
	weak var owner:FileTreeViewController4!
	
	let	menu	=	NSMenu()
	
	override init() {
		super.init()
		menu.delegate	=	self
	}
	
	var fileTreeRepository:FileTreeRepository4 {
		get {
			return	owner._fileTreeRepository!
		}
	}
	var outlineView:NSOutlineView {
		get {
			return	owner.outlineView
		}
	}
	func presentError(e:NSError) {
		owner.presentError(e)
	}
	
	func menuNeedsUpdate(menu: NSMenu) {
		menu.removeAllItems()
		
		////
		
		func getURLFromRowAtIndex(v:NSOutlineView, index:Int) -> NSURL {
			let	n	=	v.itemAtRow(index) as FileNode4
			return	n.link
		}
		func getURLFromClickingPoint(v:NSOutlineView) -> NSURL? {
			let	r1	=	v.clickedRow
			if r1 >= 0 {
				return	getURLFromRowAtIndex(v, r1)
			} else {
				return	nil
			}
		}
		func collectTargetFileURLs(v:NSOutlineView) -> [NSURL] {
			
			func getURLsFromSelection(v:NSOutlineView) -> [NSURL] {
				return
					v.selectedRowIndexes.allIndexes.map { idx in
						return	getURLFromRowAtIndex(v, idx)
				}
			}
			
			let	clickingURL		=	getURLFromClickingPoint(v)
			let	selectingURLs	=	getURLsFromSelection(v)
			if clickingURL == nil {
				return	selectingURLs
			}
			
			if contains(selectingURLs, clickingURL!) {
				return	selectingURLs
			} else {
				return	[clickingURL!]
			}
		}
		
		func getParentFolderURLOfClickingPoint(v:NSOutlineView) -> NSURL? {
			if let u2 = getURLFromClickingPoint(v) {
				let	parentFolderURL	=	u2.existingAsDirectoryFile ? u2 : u2.URLByDeletingLastPathComponent!
				assert(parentFolderURL.existingAsDirectoryFile)
				return	parentFolderURL
			}
			return	nil
		}
	
		////
	
		menu.addItem(NSMenuItem(title: "Show in Finder", reaction: { [unowned self] () -> () in
			let	targetURLs	=	collectTargetFileURLs(self.outlineView)
			NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs(targetURLs)
		}))
		
		menu.addSeparatorItem()
		
		menu.addItem(NSMenuItem(title: "New File", reaction: { [unowned self] () -> () in
			if let parentFolderURL = getParentFolderURLOfClickingPoint(self.outlineView) {
				let	r	=	FileUtility.createNewFileInFolder(parentFolderURL)
				if r.ok {
					let	newFileURL	=	r.value!
					self.owner.invalidateNodeForURL(newFileURL)
					
					let	parentNode	=	self.fileTreeRepository[parentFolderURL]!		//	Must be exists.
					self.outlineView.expandItem(parentNode)
					self.owner.editNodeForURL(newFileURL)
				} else {
					self.presentError(r.error!)
				}
			} else {
				//	Ignore. Happens by clicking empty space.
			}
		}))
		
		menu.addItem(NSMenuItem(title: "New Folder", reaction: { [unowned self] () -> () in
			Debug.assertMainThread()
			
			if let parentFolderURL = getParentFolderURLOfClickingPoint(self.outlineView) {
				let	r	=	FileUtility.createNewFolderInFolder(parentFolderURL)
				if r.ok {
					let	newFolderURL	=	r.value!
					self.owner.invalidateNodeForURL(newFolderURL)
					
					let	parentNode	=	self.fileTreeRepository[parentFolderURL]!		//	Must be exists.
					self.outlineView.expandItem(parentNode)
					self.owner.editNodeForURL(newFolderURL)
				} else {
					self.presentError(r.error!)
				}
			} else {
				//	Ignore. Happens by clicking empty space.
			}
		}))
		
		menu.addSeparatorItem()
		
		menu.addItem(NSMenuItem(title: "Delete", reaction: { [unowned self] () -> () in
			let	targetURLs	=	collectTargetFileURLs(self.outlineView)
			if targetURLs.count > 0 {
				UIDialogues.queryDeletingFilesUsingWindowSheet(self.outlineView.window!, files: targetURLs, handler: { (b:UIDialogueButton) -> () in
					switch b {
					case .OKButton:
						for u in targetURLs {
							//	TODO:	Find better way to do this.
							let	dupc	=	targetURLs.reduce(0) { sum, u1 in
								return	sum + (u.absoluteString!.hasPrefix(u1.absoluteString!) ? 1 : 0)
							}
							if dupc > 1 {
								continue
							}
							
							////
							
							var	err	=	nil as NSError?
							let	ok	=	NSFileManager.defaultManager().trashItemAtURL(u, resultingItemURL: nil, error: &err)
							assert(ok || err != nil)
							if !ok {
								self.outlineView.presentError(err!)
							}
						}
						
					case .CancelButton:
						break
					}
				})
			}
		}))

	
	}
}












