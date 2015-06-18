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







public protocol WorkspaceNavigationViewControllerDelegate: class {
	func workpaceNavigationViewControllerWantsToOpenFileAtURL(NSURL)
}


///	Provides file-tree navigation.
///	The file-tree will be stored in a file in the specified workspace.
///
///	**Workspace spec is not yet well defined, and can be changed later.**
///
///	This object equips internal scroll-view, so you should not make your own scroll view
///	to wrap this up.
///
public final class WorkspaceNavigationViewController: NSViewController {
	public weak var delegate:WorkspaceNavigationViewControllerDelegate?
	
	///	This must be a file URL to a directory with extension `eews` that contains workspace content.
	///	The directory should contain `.eonil.editor.workspace.configuration` file that contains workspace configurations.
	///	If there's no such file, this will crash program.
	public var URLRepresentation:NSURL? {
		get {
			Debug.assertMainThread()
			
			return	super.representedObject as! NSURL?
		}
		set(v) {
			Debug.assertMainThread()
			
			if v != (super.representedObject as! NSURL?) {
				if let u = URLRepresentation {
					WorkspaceSerialisation.writeRepositoryConfiguration(internalController.repository!, toWorkspaceAtURL: u)
					internalController.repository!.delegate	=	nil
					internalController.repository				=	nil
				}
				
				super.representedObject	=	v
				
				if let u = URLRepresentation {
					let	u1	=	WorkspaceSerialisation.configurationFileURLForWorkspaceAtURL(u)
					if u1.existingAsAnyFile {
						internalController.repository				=	WorkspaceSerialisation.readRepositoryConfiguration(fromWorkspaceAtURL: u)
					} else {
						internalController.repository				=	WorkspaceRepository(name: u.lastPathComponent!)
					}
					internalController.repository!.delegate	=	internalController
				}
				
				self.outlineView.reloadData()
				if let n = internalController.repository?.root {
					self._expandOpenFolderNodes(n)
				}
			}
		}
	}
	
	private func _expandOpenFolderNodes(n:WorkspaceNode) {
		Debug.assertMainThread()
		
		if n.flags.isOpenFolder {
			self.outlineView.expandItem(n, expandChildren: false)
		}
		for n1 in n.children {
			_expandOpenFolderNodes(n1)
		}
	}
	
	public func persistToFileSystem() {
		WorkspaceSerialisation.writeRepositoryConfiguration(internalController.repository!, toWorkspaceAtURL: URLRepresentation!)
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
		super.view	=	NSScrollView()
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		assert(self.view is NSScrollView)
		
		////
		
		scrollView.documentView				=	outlineView
		scrollView.hasHorizontalScroller	=	false
		scrollView.hasVerticalScroller		=	true
		
		////
		
		let	c1			=	NSTableColumn()
		c1.title		=	"Name"
		c1.identifier	=	WorkspaceNavigationTreeColumnIdentifier.Name.rawValue
		
//		let	c2			=	NSTableColumn()
//		c2.title		=	"Comment"
//		c2.identifier	=	WorkspaceNavigationTreeColumnIdentifier.Comment.rawValue
		
		outlineView.addTableColumn(c1)
//		outlineView.addTableColumn(c2)
		outlineView.outlineTableColumn		=	c1
		
		outlineView.allowsMultipleSelection	=	true
		outlineView.allowsEmptySelection	=	true
		outlineView.headerView				=	nil
		outlineView.focusRingType			=	NSFocusRingType.None
		outlineView.rowSizeStyle			=	NSTableViewRowSizeStyle.Small
		outlineView.menu					=	MenuController.menuOfController(internalController.menu)
		
		//	This is required to intoroduce small delay when starting editing of a node label.
		outlineView.doubleAction			=	"dummyDoubleActionHandler:"
		
		outlineView.selectionHighlightStyle				=	NSTableViewSelectionHighlightStyle.Regular
//		outlineView.draggingDestinationFeedbackStyle	=	NSTableViewDraggingDestinationFeedbackStyle.SourceList
		
		outlineView.registerForDraggedTypes([NSFilenamesPboardType])
		
		outlineView.setDataSource(internalController)
		outlineView.setDelegate(internalController)
		
		internalController.owner			=	self
	}
	
	////
	
	internal let internalController		=	InternalController()
	
	////
	
	private let _outlineView			=	NSOutlineView()
	
	//
	@objc
	private func dummyDoubleActionHandler(AnyObject?) {
		
	}
}


internal extension WorkspaceNavigationViewController {
	var outlineView:NSOutlineView {
		get {
			return	_outlineView
		}
	}
	var scrollView:NSScrollView {
		get {
			return	view as! NSScrollView
		}
	}
}



































