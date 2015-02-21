//
//  WorkspaceNavigationViewController.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorUIComponents

public final class WorkspaceNavigationViewController: NSViewController {
	
	///	This must be a file URL to a directory with extension `eews` that contains workspace content.
	///	The directory should contain `.eonil.editor.workspace.configuration` file that contains workspace configurations.
	///	If there's no such file, this will crash program.
	public var URLRepresentation:NSURL? {
		get {
			return	super.representedObject as! NSURL?
		}
		set(v) {
			if v != (super.representedObject as! NSURL?) {
				if let u = URLRepresentation {
					WorkspaceSerialisation.writeRepositoryConfiguration(_internalController.repository!, toWorkspaceAtURL: u)
					_internalController.repository	=	nil
				}
				
				super.representedObject	=	v
				
				if let u = URLRepresentation {
					let	u1	=	WorkspaceSerialisation.configurationFileURLForWorkspaceAtURL(u)
					if u1.existingAsAnyFile {
						_internalController.repository	=	WorkspaceSerialisation.readRepositoryConfiguration(fromWorkspaceAtURL: u)
					} else {
						_internalController.repository	=	WorkspaceRepository(name: u.lastPathComponent!)
					}
				}
				
				self.outlineView.reloadData()
			}
		}
	}
	
	public func synchroniseToFileSystem() {
		WorkspaceSerialisation.writeRepositoryConfiguration(_internalController.repository!, toWorkspaceAtURL: URLRepresentation!)
	}
	
	@availability(*,unavailable)
	public override var representedObject:AnyObject? {
		get {
			return	URLRepresentation
		}
		set(v) {
			precondition(v is NSURL?, "Only `NSURL` value is allowed.")
			self.URLRepresentation	=	v as! NSURL?
		}
	}
	
	public override var view:NSView {
		willSet {
			fatalError("You cannot reset `view` of this object.")
		}
	}
	public override func loadView() {
		super.view	=	NSOutlineView()
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		assert(self.view is NSOutlineView)
		
		let	c1			=	NSTableColumn()
		c1.title		=	"Name"
		c1.identifier	=	COLUMN_NAME
		
		let	c2			=	NSTableColumn()
		c2.title		=	"Comment"
		c2.identifier	=	COLUMN_COMMENT
		
		outlineView.addTableColumn(c1)
		outlineView.addTableColumn(c2)
		outlineView.outlineTableColumn	=	c1
		
		outlineView.allowsMultipleSelection	=	true
		outlineView.allowsEmptySelection	=	true
		outlineView.selectionHighlightStyle	=	NSTableViewSelectionHighlightStyle.SourceList
		outlineView.rowSizeStyle			=	NSTableViewRowSizeStyle.Small
		outlineView.menu					=	MenuController.menuOfController(_internalController.menu)
		
		outlineView.setDataSource(_internalController)
		outlineView.setDelegate(_internalController)
		
		_internalController.owner			=	self
	}
	
	////
	
	private let	_internalController		=	InternalController()
}

private extension WorkspaceNavigationViewController {
	var outlineView:NSOutlineView {
		get {
			return	self.view as! NSOutlineView
		}
	}
}


























///	MARK:
///	MARK:	InternalController

private final class InternalController: NSObject {
	let menu			=	WorkspaceNavigationContextMenuController()
	var repository		=	nil as WorkspaceRepository?
	
	override init() {
		super.init()
		
		menu.showInFinder.reaction	=	{ [unowned self] in
			let	fn	=	self.owner.outlineView.clickedNode
			let	sns	=	self.owner.outlineView.selectedNodes
			
			let	hasFocus		=	fn != nil
			let	hasSelection	=	sns.count > 0
			let	rootFocused		=	fn === self.repository!.root
			let	rootSelected	=	sns.filter({ n in n === self.repository!.root }).count > 0
			
			let	fu	=	self.owner.clickedURL
			let	sus	=	self.owner.selectedURLs
			let aus =   (fu == nil ? [] : [fu!]) + sus
			
			NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs(aus)
		}
		
		NSNotificationCenter.defaultCenter().addObserverForName(
			NSMenuDidBeginTrackingNotification,
			object: MenuController.menuOfController(menu),
			queue: nil) { [unowned self](n:NSNotification!) -> Void in
				let	fn	=	self.owner.outlineView.clickedNode
				let	sns	=	self.owner.outlineView.selectedNodes
				
				let	hasFocus		=	fn != nil
				let	hasSelection	=	sns.count > 0
				let	rootFocused		=	fn === self.repository!.root
				let	rootSelected	=	sns.filter({ n in n === self.repository!.root }).count > 0
				
				self.menu.showInFinder.enabled				=	hasFocus || hasSelection
				self.menu.newFile.enabled					=	hasFocus || hasSelection
				self.menu.newFolder.enabled					=	hasFocus || hasSelection
				self.menu.newFolderWithSelection.enabled	=	(hasFocus || hasSelection) && (rootFocused == false && rootSelected == false)
				self.menu.delete.enabled					=	(hasFocus || hasSelection) && (rootFocused == false && rootSelected == false)
				self.menu.addAllUnregistredFiles.enabled	=	hasFocus || hasSelection
				self.menu.removeAllMissingFiles.enabled		=	hasFocus || hasSelection
				self.menu.note.enabled						=	hasFocus || hasSelection
		}
	}
	weak var owner:WorkspaceNavigationViewController! {
		willSet {
			assert(owner == nil)
		}
	}
}

private extension WorkspaceNavigationViewController {
	var	clickedURL:NSURL? {
		get {
			if let u = URLRepresentation, let n = outlineView.clickedNode {
				let	u1	=	u.URLByDeletingLastPathComponent!
				return	u1.URLByAppendingPath(n.path)
			}
			return	nil
		}
	}
	var	selectedURLs:[NSURL] {
		get {
			if let u = URLRepresentation {
				let	u1	=	u.URLByDeletingLastPathComponent!
				return	outlineView.selectedNodes.map({ n in u1.URLByAppendingPath(n.path) })
			}
			return	[]
		}
	}
}
private extension NSOutlineView {
	var clickedNode:WorkspaceNode? {
		get {
			return	clickedRow == -1 ? nil : self.itemAtRow(clickedRow) as! WorkspaceNode?
		}
	}
	var selectedNodes:[WorkspaceNode] {
		get {
			return	selectedRowIndexes.allIndexes.map({ idx in self.itemAtRow(idx) as! WorkspaceNode })
		}
	}
}

private extension NSURL {
	func URLByAppendingPath(path:WorkspacePath) -> NSURL {
		if path.components.count == 0 {
			return	self
		}
		let	u	=	self.URLByAppendingPath(path.parentPath)
		let	u1	=	u.URLByAppendingPathComponent(path.components.last!)
		return	u1
	}
}

extension InternalController: NSOutlineViewDataSource {
	@objc
	func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		let n	=	item as! WorkspaceNode
		return	n.children.count > 0
	}
	@objc
	func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		if item == nil {
			return	repository == nil ? 0 : 1
		}
		let n	=	item as! WorkspaceNode
		return	n.children.count
	}
	@objc
	func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		if item == nil {
			return	repository!.root
		}
		let	n	=	item as! WorkspaceNode
		return	n.children[index]
	}
	@objc
	func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
		return	item as! WorkspaceNode
	}
	@objc
	func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		let	v	=	CellView(tableColumn!.identifier)
		v.nodeRepresentation	=	item as! WorkspaceNode
		return	v
	}
}


extension InternalController: NSOutlineViewDelegate {
	
}





private final class CellView: NSTableCellView {
	var	columnIdentifier:String	=	""
	
	init(_ columnIdentifier:String) {
		super.init()
		self.columnIdentifier	=	columnIdentifier
		
		switch self.columnIdentifier {
		case COLUMN_NAME:
			let	v1	=	NSImageView()
			let	v2	=	NSTextField()
			self.addSubview(v1)
			self.addSubview(v2)
			
			v2.editable			=	false
			v2.bordered			=	false
			v2.backgroundColor	=	NSColor.clearColor()
			
			self.imageView		=	v1
			self.textField		=	v2
			
		case COLUMN_COMMENT:
			let	v2	=	NSTextField()
			self.addSubview(v2)
			
			v2.editable			=	false
			v2.bordered			=	false
			v2.backgroundColor	=	NSColor.clearColor()
			self.textField		=	v2
			
		default:
			fatalError("Unknown column identifier `\(self.columnIdentifier)` detected.")
		}
	}
	
	@availability(*,unavailable)
	override init() {
		super.init()
	}
	
	@availability(*,unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported initializer.")
	}
	
	@availability(*,unavailable)
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		
	}
	
	
	
	var nodeRepresentation:WorkspaceNode? {
		get {
			return	super.objectValue as! WorkspaceNode?
		}
		set(v) {
			super.objectValue	=	v
			
			switch self.columnIdentifier {
			case COLUMN_NAME:
				let	n	=	v!.name
				let	c	=	v!.comment ||| ""
				let	t	=	c == "" ? n : "\(n) (\(c))"
				
				let	m	=	v!.kind == WorkspaceNodeKind.Folder ? Icons.folder : Icons.file
				
				imageView!.image		=	m
				textField!.stringValue	=	t
				
			case COLUMN_COMMENT:
				textField!.stringValue	=	v!.comment ||| ""

			default:
				fatalError("Unknown column identifier `\(self.columnIdentifier)` detected.")
			}
		}
	}
	
	@availability(*,unavailable)
	override var objectValue:AnyObject? {
		willSet(v) {
			precondition(v is WorkspaceNode, "Only `WorkspaceNode` type is acceptable.")
		}
//		get {
//			
//		}
//		set(v) {
//			
//		}
	}
}




private extension NSImage {
	var templateImage:NSImage {
		get {
			let	m	=	self.copy() as! NSImage
			m.setTemplate(true)
			return	m
		}
	}
}



private struct Icons {
	static let	folder	=	IconPalette.FontAwesome.WebApplicationIcons.folderO.image.templateImage
	static let	file	=	IconPalette.FontAwesome.WebApplicationIcons.fileO.image.templateImage
}

private let	COLUMN_NAME		=	"NAME"
private let	COLUMN_COMMENT	=	"COMMENT"





















































///	MARK:
///	MARK:

extension InternalController: WorkspaceRepositoryDelegate {
	func workspaceRepositoryDidCreateNode(node: WorkspaceNode) {
		
	}
	func workspaceRepositoryWillMoveNode(node: WorkspaceNode) {
		
	}
	func workspaceRepositoryDidMoveNode(node: WorkspaceNode) {
		
	}
	func workspaceRepositoryWillDeleteNode(node: WorkspaceNode) {
		
	}
	
	
	
	func workspaceRepositoryDidOpenSubworkspaceAtNode(node: WorkspaceNode) {
		
	}
	func workspaceRepositoryWillCloseSubworkspaceAtNode(node: WorkspaceNode) {
		
	}
}










