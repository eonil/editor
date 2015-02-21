//
//  WorkspaceNodeUtility.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/22.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

extension WorkspaceRepository {
	func deleteNodes(nodes:[WorkspaceNode]) {
		for n in nodes {
			//	A node can be detached(deleted) by previous delete operation.
			if n.isAttached {
				n.delete()
			}
		}
	}
}













/////	Filters only parent nodes by stripping any included child nodes.
/////	Designed for tree-node deletion.
/////
/////	For example, with given tree,
/////
/////				A
/////			   / \
/////			  B   C
/////			 / \   \
/////			D   E   F
/////
/////
/////	Assume we have B,C,D,F.
/////
/////				_
/////			   / \
/////			  B   C
/////			 / \   \
/////			D   _   F
/////
/////	After filtering, only B and C remains.
/////
/////				_
/////			   / \
/////			  B   C
/////			 / \   \
/////			_   _   _
/////
//private func topologicFilter(nodes:[WorkspaceNode]) -> [WorkspaceNode] {
//	let	ns1	=	nodes
//	let	ns2	=	nodes
//	
//	for n1 in ns1 {
//		for n2 in ns2 {
//			n1.isAncesterOfNode(n2)
//		}
//	}
//}
//
//private extension WorkspaceNode {
//	///	Returns `true` if current node is one of ancesters of target `node`.
//	func isAncesterOfNode(node:WorkspaceNode) -> Bool {
//		var	n	=	node.parent
//		while n != nil {
//			if n === self {
//				return	true
//			}
//			n	=	n!.parent
//		}
//		return	false
//	}
//}








