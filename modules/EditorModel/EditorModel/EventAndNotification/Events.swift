//
//  Events.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/25.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon

public extension ApplicationModel {
	public enum Event: BroadcastableEventType {
		public typealias	Sender	=	ApplicationModel
		case DidAddWorkspace(workspace: WorkspaceModel)
		case WillRemoveWorkspace(workspace: WorkspaceModel)
		case DidChangeCurrentWorkspace(workspace: WorkspaceModel?)
		case WillChangeCurrentWorkspace(workspace: WorkspaceModel?)

		case Debug(DebuggingModel.Event.Notification)
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
	public enum Event: BroadcastableEventType {
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

public extension DebuggingModel {
	public enum Event: BroadcastableEventType {
		public typealias	Sender	=	DebuggingModel
		case WillChangeCurrentTarget(target: DebuggingTargetModel?)
		case DidChangeCurrentTarget(target: DebuggingTargetModel?)
	}
}

public extension DebuggingTargetModel {
	public enum Event: BroadcastableEventType {
		public typealias	Sender	=	DebuggingTargetModel
		case WillChangeExecution(execution: DebuggingTargetExecutionModel?)
		case DidChangeExecution(execution: DebuggingTargetExecutionModel?)
	}
}

public extension DebuggingTargetExecutionModel {
	public enum Event: BroadcastableEventType {
		public typealias	Sender	=	DebuggingTargetExecutionModel
		case WillChangeState(state: DebuggingTargetExecutionModel.State)
		case DidChangeState(state: DebuggingTargetExecutionModel.State)
		case WillChangeRunnableCommands(commands: Set<DebuggingCommand>)
		case DidChangeRunnableCommands(commands: Set<DebuggingCommand>)
	}
}

























