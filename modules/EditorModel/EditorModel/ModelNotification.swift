//
//  ModelNotification.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/24.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public enum ApplicationNotification: SubcategoryNotificationType {
	/// Newrly created workspace will also be notified using this.
	case DidOpenWorkspace(workspace: WorkspaceModel)
	case WillCloseWorkspace(workspace: WorkspaceModel)
}

public enum WorkspaceNotification: SubcategoryNotificationType {
	case WillRelocate(workspace: WorkspaceModel, from: NSURL, to: NSURL)
	case DidRelocate(workspace: WorkspaceModel, from: NSURL, to: NSURL)
}

public enum FileTreeNotification: SubcategoryNotificationType {
	case DidCreateRoot(tree: FileTreeModel, root: FileNodeModel)
	case WillDeleteRoot(tree: FileTreeModel, root: FileNodeModel)
}

public enum FileNodeNotification: SubcategoryNotificationType {
	case DidInsertSubnode(node: FileNodeModel, subnode: FileNodeModel, index: Int)
	case WillDeleteSubnode(node: FileNodeModel, subnode: FileNodeModel, index: Int)
	case WillChangeGrouping(node: FileNodeModel, old: Bool, new: Bool)
	case DidChangeGrouping(node: FileNodeModel, old: Bool, new: Bool)
	case WillChangeName(node: FileNodeModel, old: String, new: String)
	case DidChangeName(node: FileNodeModel, old: String, new: String)
	case WillChangeComment(node: FileNodeModel, old: String?, new: String?)
	case DidChangeComment(node: FileNodeModel, old: String?, new: String?)
}



// Delegate is good for single-cast, but not for multi-case because we need to duplicate 
// multicasting for every method.
//
// Multicasting channel is good in many ways, but it requires closure. And that's verbose,
// and annoying. Connecting handler is annoying. Also, single-element tuple cannot have 
// a label, so this is not an option.
//
// Notification is well balanced and simple. Though we need to code every cases with typing 
// proper signatures... it's matter of IDE, so it will be better over time.








