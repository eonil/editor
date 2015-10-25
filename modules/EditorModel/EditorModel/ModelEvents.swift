//
//  ModelEvents.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/25.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public extension ApplicationModel {
	public enum Event: BroadcastableEventType {
		public typealias	Sender	=	ApplicationModel
		case DidAddWorkspace(workspace: WorkspaceModel)
		case WillRemoveWorkspace(workspace: WorkspaceModel)
		case DidBeginCurrentWorkspace(workspace: WorkspaceModel)
		case WillEndCurrentWorkspace(workspace: WorkspaceModel)
	}
}

public extension WorkspaceModel {
	public enum Event: BroadcastableEventType {
		public typealias	Sender	=	WorkspaceModel
		case WillRelocate(from: NSURL, to: NSURL)
		case DidRelocate(from: NSURL, to: NSURL)
	}
}

public extension FileTreeModel {
	public enum FileTreeEvent: BroadcastableEventType {
		public typealias	Sender	=	FileTreeModel
		case DidCreateRoot(root: FileNodeModel)
		case WillDeleteRoot(root: FileNodeModel)
	}
}

public extension FileNodeModel {
	public enum Event: BroadcastableEventType {
		public typealias	Sender	=	FileNodeModel
		case DidInsertSubnode(subnode: FileNodeModel, index: Int)
		case WillDeleteSubnode(subnode: FileNodeModel, index: Int)
		case WillChangeGrouping(old: Bool, new: Bool)
		case DidChangeGrouping(old: Bool, new: Bool)
		case WillChangeName(old: String, new: String)
		case DidChangeName(old: String, new: String)
		case WillChangeComment(old: String?, new: String?)
		case DidChangeComment(old: String?, new: String?)
	}
}

public extension BuildModel {
	public enum Event: BroadcastableEventType {
		public typealias	Sender	=	BuildModel
		case WillChangeRunnableCommand
		case DidChangeRunnableCommand
	}
}

public extension DebuggingTargetExecutionModel {
	public enum Event: BroadcastableEventType {
		public typealias	Sender	=	DebuggingTargetExecutionModel
		case WillChangeState
		case DidChangeState
	}

}


