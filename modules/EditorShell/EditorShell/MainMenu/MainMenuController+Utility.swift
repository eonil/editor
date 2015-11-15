//
//  MainMenuController+Utility.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorModel

extension MainMenuController {
	static func hostFileNodeForNewFileSubentryOperationInFileTree(tree: FileTreeModel) -> WorkspaceItemNode? {
		let	ns	=	tree.projectUIState.sustainingFileSelection
		guard ns.count == 1 else {
			return	nil
		}
		guard let n = ns.first else {
			return	nil
		}
		return	n.isGroup ? n : n.supernode
	}
}