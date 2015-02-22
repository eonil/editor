//
//  SelectionQuery.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/22.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit





///	Represents user's selection in navigation tree.
struct SelectionQuery {
	let	node:Selection<WorkspaceNode>
	let	URL:Selection<NSURL>
	
	let	rootHotSelection:Bool
	let	rootCoolSelection:Bool
	//	let	rootAnySelection:Bool
	
	///	Specified workspace can be empty (no URL set).
	///
	///	:param:	repository		Pass `nil` if the repository currently does not exist.
	///
	init(controller:WorkspaceNavigationViewController, repository:WorkspaceRepository?) {
		let	fn	=	controller.outlineView.clickedNode
		let	sns	=	controller.outlineView.selectedNodes
		
		let	fu	=	controller.clickedURL
		let	sus	=	controller.selectedURLs
		
		node	=	Selection(hot: fn, cool: sns)
		URL		=	Selection(hot: fu, cool: sus)
		
		let	r	=	repository?.root
		
		rootHotSelection	=	node.hot === r
		rootCoolSelection	=	node.cool.filter({ n in n === r }).count > 0
		//		rootAnySelection	=	rootHotSelection || rootCoolSelection
	}
}

struct Selection<T> {
	///	Selection that temporaily focused by mouse.
	let	hot:T?
	
	///	Selection that explicitly selected by mouse.
	let	cool:[T]
	
	///	`hot` + `cool`.
	var all:[T] {
		get {
			return	(hot == nil ? [] : [hot!]) + cool
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
