//
//  Dropping.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/28.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorUIComponents

struct Dropping {
	let	internals:InternalController
	
	enum Op {
		case Copy
		case Move
		
		static func determinateOp(info:NSDraggingInfo, currentOutlineView:NSOutlineView) -> Op {
			if info.draggingSource() === currentOutlineView {
				return	Move
			}
			return	Copy
		}
	}
	
	func processDropping(info:NSDraggingInfo, destinationNode n:WorkspaceNode, destinationChildIndex index:Int, operation op:Op) {
		let	pb	=	info.draggingPasteboard()
		let	ps	=	pb.propertyListForType(NSFilenamesPboardType) as! [String]
		let	us	=	ps.map({ p in NSURL(fileURLWithPath: p)! })
		
		switch op {
		case Op.Copy:	processCopyDropping(sourceURLs: us, destinationNode: n, destinationChildIndex: index)
		case Op.Move:	processMoveDropping(sourceURLs: us, destinationNode: n, destinationChildIndex: index)
		}
	}
	func processCopyDropping(sourceURLs us:[NSURL], destinationNode n:WorkspaceNode, destinationChildIndex index:Int) {
		for u in us {
			let	c	=	u.lastPathComponent!
			let	nu	=	internals.owner!.URLRepresentation!.URLByAppendingPath(n.path)
			let	u1	=	nu.URLByDeletingLastPathComponent!.URLByAppendingPathComponent(c)
			
			var	e	=	nil as NSError?
			let	ok	=	NSFileManager.defaultManager().copyItemAtURL(u, toURL: u1, error: &e)
			if ok == false {
				n.createChildNodeAtIndex(index, asKind: WorkspaceNodeKind.File, withName: c)
			} else {
				UIDialogues.alertModally("Could not copy some files.", comment: nil, style: NSAlertStyle.CriticalAlertStyle)
				break
			}
		}
	}
	func processMoveDropping(sourceURLs us:[NSURL], destinationNode n:WorkspaceNode, destinationChildIndex index:Int) {
		for u in us {
			let	c	=	u.lastPathComponent!
			let	nu	=	internals.owner!.URLRepresentation!.URLByAppendingPath(n.path)
			let	u1	=	nu.URLByDeletingLastPathComponent!.URLByAppendingPathComponent(c)
			
			var	e	=	nil as NSError?
			let	ok	=	NSFileManager.defaultManager().moveItemAtURL(u, toURL: u1, error: &e)
			if ok == false {
				let	n1	=	internals.owner.nodeForAbsoluteFileURL(u)!
				n1.move(toParentNode: n, atIndex: index, asName: n1.name)
			} else {
				UIDialogues.alertModally("Could not move some files.", comment: nil, style: NSAlertStyle.CriticalAlertStyle)
				break
			}
		}
	}
	
}
