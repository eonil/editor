//
//  WorkspaceItemTree+Snapshot.swift
//  WorkspaceItemTree
//
//  Created by Hoon H. on 2015/10/17.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

extension WorkspaceItemTree {
//	convenience init(snapshot: String, repairAutomatically: Bool) {
//	}
	convenience init(snapshot: String) throws {
		self.init()

		let	list	=	try WorkspaceItemSerialization.deserializeList(snapshot)
		precondition(list.count > 0)
		precondition(list[0].path == WorkspaceItemPath.root)
		createRoot()
		for item in list[list.startIndex.successor()..<list.endIndex] {
			let	superpath	=	item.path.pathByDeletingLastComponent()
			if let supernode = root.findNodeForPath(superpath) {
				let	node	=	WorkspaceItemNode(name: item.path.parts.last!, isGroup: item.group)
				node.comment	=	item.comment
				supernode.subnodes.append(node)
			}
			else {
				fatalError("Cannot find supernode for path `\(superpath)`.")
			}
		}
	}

	func snapshot() -> String {
		var items	=	Array<WorkspaceItemSerialization.PersistentItem>()
		func appendNode(node: WorkspaceItemNode) {
			let	path	=	node.resolvePath()
			let	group	=	node.isGroup
			let	comment	=	node.comment
			let	item	=	(path, group, comment)
			items.append(item)
		}

		root._applyRecursively() { node in
			appendNode(node)
		}

		let	snapshot	=	WorkspaceItemSerialization.serializeList(items)
		return	snapshot
	}
}

private extension WorkspaceItemNode {
	private func _applyRecursively(code: (WorkspaceItemNode)->()) {
		code(self)
		for subnode in subnodes {
			subnode._applyRecursively(code)
		}
	}
}