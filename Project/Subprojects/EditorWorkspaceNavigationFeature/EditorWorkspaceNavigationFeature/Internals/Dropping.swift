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
		assert(index >= 0)
		assert(index <= n.children.count)
		
		let	draggingFiles			=	getDraggingURLs(info)
		
		////
		
		switch op {
		case Op.Copy:	processCopyDropping(sourceURLs: draggingFiles, destinationNode: n, destinationChildIndex: index, skipCopyingIntoSamePlace: true)
		case Op.Move:	processMoveDropping(sourceURLs: draggingFiles, destinationNode: n, destinationChildIndex: index)
		}
	}

	///	This just copies the file sequentially as many as possible.
	///	Operation will be halted on any error.
	///
	///	:param:		skipCopyingIntoSamePlace
	///				If this is set to `true`, this will skip URLs that are same from source and destination locations.
	///				Otherwise, same location is incopyable, and will cause an error that will be displayed to user.
	func processCopyDropping(sourceURLs us:[NSURL], destinationNode n:WorkspaceNode, destinationChildIndex index:Int, skipCopyingIntoSamePlace:Bool)  {
		for u in us {
			let	c	=	u.lastPathComponent!
			let	nu	=	internals.owner!.URLRepresentation!.URLByAppendingPath(n.path)
			let	u1	=	nu.URLByAppendingPathComponent(c)
			let	k	=	u.existingAsDirectoryFile ? WorkspaceNodeKind.Folder : WorkspaceNodeKind.File
			
			var	e	=	nil as NSError?
			let	ok	=	(skipCopyingIntoSamePlace && wouldBeSame(u, u1)) || NSFileManager.defaultManager().copyItemAtURL(u, toURL: u1, error: &e)
			if ok {
				let	cn	=	n.createChildNodeAtIndex(index, asKind: k, withName: c)
				internals.owner!.outlineView.insertItemsAtIndexes(NSIndexSet(index: index), inParent: n, withAnimation: NSTableViewAnimationOptions.SlideDown)
				cn.fillAllDescendantsFromFileSystemWithWorkspaceURL(internals.owner!.URLRepresentation!)
			} else {
				internals.owner!.presentError(e!)
				return
			}
		}
	}
	
	
	
	
	
	
	///	This just moves the file sequentially as many as possible.
	///	Operation will be halted on any error.
	func processMoveDropping(sourceURLs us:[NSURL], destinationNode n:WorkspaceNode, destinationChildIndex index:Int) {
		for u in us {
			let	c	=	u.lastPathComponent!
			let	nu	=	internals.owner!.URLRepresentation!.URLByAppendingPath(n.path)
			let	u1	=	nu.URLByAppendingPathComponent(c)
			
			var	e	=	nil as NSError?
			let	ok	=	NSFileManager.defaultManager().moveItemAtURL(u, toURL: u1, error: &e)
			if ok {
				let	n1	=	internals.owner.nodeForAbsoluteFileURL(u)!
				let	n2	=	n1.parent!
				let	idx	=	n2.indexOfNode(n1)!
				n2.moveChildNode(idx, toNewParentNode: n, atNewIndex: index)
				internals.owner!.outlineView.moveItemAtIndex(idx, inParent: n2, toIndex: index, inParent: n)
			} else {
				internals.owner!.presentError(e!)
				return
			}
		}
	}
	
}




























private extension WorkspaceNode {
	///	Current node must be empty.
	///	If current node is not a directory node, this is no-op.
	///
	///	:param:		workspaceURL
	///				URL of workspace root node. A connection point to file-system.
	///
	///	:result:	If any error occured and operation unexpectedily quit,
	///				this will return an `NSError` that caused it.
	///				`nil` for otherwise.
	func fillAllDescendantsFromFileSystemWithWorkspaceURL(workspaceURL:NSURL) -> NSError? {
		assert(self.children.count == 0)
		
		let	u	=	workspaceURL.URLByAppendingPath(self.path)
		if u.existingAsDirectoryFile {
			var	err	=	nil as NSError?
			let	opt	=	NSDirectoryEnumerationOptions.SkipsHiddenFiles | NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants
			let	cus	=	NSFileManager.defaultManager().enumeratorAtURL(u, includingPropertiesForKeys: nil, options: opt, errorHandler: { (issueURL:NSURL!, issueError:NSError!) -> Bool in
				err	=	issueError
				return	false
			})!
			
			for co in cus {
				if err != nil {
					return	err
				}
				
				let	cu		=	co as! NSURL
				let	kind	=	cu.existingAsDirectoryFile ? WorkspaceNodeKind.Folder : WorkspaceNodeKind.File
				let	name	=	cu.lastPathComponent!
				let	cn		=	self.createChildNodeAtLastAsKind(kind, withName: name)
				let	cerr	=	cn.fillAllDescendantsFromFileSystemWithWorkspaceURL(workspaceURL)
				
				if cerr != nil {
					return	cerr
				}
			}
			
			if err != nil {
				return	err
			}
		}

		return	nil
	}
}






//private func filterFilesThatAreNotInDirectory(files:[NSURL], directory:NSURL) -> [NSURL] {
//	let	fs1	=	files.filter({ f in
//		let	f1	=	f.URLByDeletingLastPathComponent!
//		return	f1 != directory
//	})
//	return	fs1
//}
////private func findNameDuplicationsForDragging(source:NSDraggingInfo, destination:WorkspaceNode, workspaceURL:NSURL) -> NameDuplications {
////	let	us1	=	getDraggingURLs(source)
////	let	us2	=	destination.children.map({ n in workspaceURL.URLByAppendingPath(n.path) })
////	let	dup	=	findNameDuplications(us1+us2)
////	
////	return	dup
////}
//private func findNameDuplications(us:[NSURL]) -> NameDuplications {
//	var	countingTable	=	[:] as [String:Int]
//	for u in us {
//		let	n	=	u.lastPathComponent!
//		if let c = countingTable[n] {
//			countingTable[n]	=	c+1
//		} else {
//			countingTable[n]	=	1
//		}
//	}
//	
//	let	us1	=
//		us.filter({ u in
//			let	n	=	u.lastPathComponent!
//			let	c	=	countingTable[n]
//			return	c > 1
//		})
//	
//	return	NameDuplications(URLs: us1)
//}
//
//private func alertNameDuplicationError(duplicatedNames:[String]) {
//	let	txt	=	"Some files have duplicated names, and cannot be placed into same directory. Operation cancelled"
//	let	cmt	=	nil as String?
//	UIDialogues.alertModally(txt, comment: cmt, style: NSAlertStyle.WarningAlertStyle)
//}
//
//private struct NameDuplications {
//	var	URLs	=	[] as [NSURL]
//	
//	var names:[String] {
//		get {
//			return	URLs.map({ u in u.lastPathComponent! })
//		}
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
//
//
//
//
//
//
//
//private struct URLDuplication {
//	var	exactDuplications:[NSURL]
//	var	nameOnlyDuplications:[NSURL]
//}















///	When you comparing two file URLS, two URLs a=may be different by path, but
///	can be equal in file reference level. (inode hard-link) This considers such
///	duplication.
private func wouldBeSame(a:NSURL, b:NSURL) -> Bool {
	let	u1	=	a.URLByDeletingLastPathComponent!
	let	u2	=	b.URLByDeletingLastPathComponent!
	
	precondition(u1.existingAsDirectoryFile)
	precondition(u2.existingAsDirectoryFile)
	
	let	eq1	=	u1.fileReferenceURL() == u2.fileReferenceURL()
	let	eq2	=	a.lastPathComponent! == b.lastPathComponent!
	
	return	eq1 && eq2
}


private func getDraggingURLs(info:NSDraggingInfo) -> [NSURL] {
	let	pb	=	info.draggingPasteboard()
	let	ps	=	pb.propertyListForType(NSFilenamesPboardType) as! [String]
	let	us	=	ps.map({ p in NSURL(fileURLWithPath: p)! })
	return	us
}




























