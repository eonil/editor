//
//  ModelNotification.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/24.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

/// Event definitions of `EditorModel`.
///
public enum ModelNotification {
	case ApplicationNotification
	case FileTreeNotification(EditorModel.FileTreeNotification)
	case FileNodeNotification(EditorModel.FileNodeNotification)

}

public enum FileTreeNotification: SubcategoryNotificationType {
	case DidCreateRoot(tree: FileTreeModel, root: FileNodeModel)
	case WillDeleteRoot(tree: FileTreeModel, root: FileNodeModel)
}

public enum FileNodeNotification: SubcategoryNotificationType {
	case DidInsertSubnode(supernode: FileNodeModel, subnode: FileNodeModel, index: Int)
	case WillDeleteSubnode(supernode: FileNodeModel, subnode: FileNodeModel, index: Int)
	case WillChangeName(node: FileNodeModel, old: String, new: String)
	case DidChangeName(node: FileNodeModel, old: String, new: String)
	case WillChangeGrouping(node: FileNodeModel, old: Bool, new: Bool)
	case DidChangeGrouping(node: FileNodeModel, old: Bool, new: Bool)
	case WillChangeComment(node: FileNodeModel, old: String, new: String)
	case DidChangeComment(node: FileNodeModel, old: String, new: String)
}


















