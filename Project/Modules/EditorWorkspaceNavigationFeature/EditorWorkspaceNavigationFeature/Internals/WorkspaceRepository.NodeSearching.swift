//
//  WorkspaceRepository.NodeSearching.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/28.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

extension WorkspaceRepository {
	///	Look for a node for the workspace path.
	///	This just calls `WorkspaceNode.nodeForPath` on `root`.
	func nodeForPath(path:WorkspacePath) -> WorkspaceNode? {
		return	self.root.nodeForPath(path)
	}
}

extension WorkspaceNode {
	///	Assume `/` as path component separator,
	///	`/` (no component) returns `self`.
	///	`/foo` returns direct subnode with name `foo`.
	///	`/foo/bar` returns secondary subnode with name `bar` of direct subnode with name `foo`.
	func nodeForPath(path:WorkspacePath) -> WorkspaceNode? {
		if path.components.count == 0 {
			return	self
		}
		
		let	n	=	path.components.first!
		let	n1	=	self.nodeForName(n)
		
		return	n1?.nodeForPath(path.pathByDeletingFirstComponent())
	}
}