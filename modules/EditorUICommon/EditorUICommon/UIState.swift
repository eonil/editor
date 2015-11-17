//
//  UIState.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon
import EditorModel
import LLDBWrapper




/// Now I hate fucking deep object graph.
/// Fuck'em.
///
/// Register observer on `Notification<T,UIState.Event>` to receive
/// notifications where `T` is a target model type.
///
///
///
public struct UIState {

	///

	public enum Event {
		case Invalidate
	}









	///

	public enum ForWorkspaceModel {
		public typealias	Notification	=	EditorModel.Notification<WorkspaceModel, Event>
	}

	public enum ForFileTreeModel {
		public typealias	Notification	=	EditorModel.Notification<FileTreeModel, Event>
	}




}








public protocol UIStateType {
}
public extension UIStateType {
	public func test1() {
	}

	/// Performs batched read using a function.
	public func with(@noescape code: (state: Self)->()) {
		code(state: self)
	}

	/// Performs batched write using a function.
	///
	/// If you perform multiple mutations on a UI state directly,
	/// each mutation will trigger global notification. And those
	/// extra notifications are usually just duplicated and very 
	/// likely to trigger unnecessary UI rendering processing.
	/// 
	/// To avoid such cost, use this method. This method copies UI
	/// state locally, and performs mutations on the copy, and 
	/// re-assigns the mutated copy. Mutation count will become 1,
	/// and so on to the notifications.
	public mutating func mutate(@noescape mutation: (inout state: Self)->()) {
		var	copy	=	self
		mutation(state: &copy)
		self	=	copy
	}
}

public struct WorkspaceUIState: DefaultInstantiatableUIStateType {
	public var navigationPaneVisibility: Bool	=	false
	public var inspectionPaneVisibility: Bool	=	false
	public var consolePaneVisibility: Bool		=	false


	public enum Navigator {
		case Project
		case Issue
		case Debug
	}
	public enum Pane {
		case Navigation(Navigator)
		case Editor
	}

	public var paneSelection		=	Pane.Navigation(.Project)

	public var debuggingSelection		:	(target: DebuggingTargetModel?, thread: LLDBThread?, frame: LLDBFrame?)		=	(nil, nil, nil)
	public var editingSelection		:	NSURL?
}


public struct ProjectUIState: DefaultInstantiatableUIStateType {
//	public var temporalFileGrabbing		:	WorkspaceItemNode?		// Cannot be implemented because Cocoa menu does not support mutation on open/close event.
	public var sustainingFileSelection	=	[WorkspaceItemNode]()
}























public extension ApplicationModel {
}
public extension WorkspaceModel {
	/// Fires a `Notification<WorkspaceModel,UIState.Event>` after state change.
	public var overallUIState: WorkspaceUIState {
		get {
			return	UIStateBox.forModel(self, key: WorkspaceModel.overallUIStateKey).state
		}
		set {
			UIStateBox.forModel(self, key: WorkspaceModel.overallUIStateKey).state	=	newValue
			Notification(self, UIState.Event.Invalidate).broadcast()
		}
	}

	///

	private static let	overallUIStateKey	=	UIStateKey()
}
public extension FileTreeModel {
	/// Fires a `Notification<FileTreeModel,UIState.Event>` after state change.
	public var projectUIState: ProjectUIState {
		get {
			return	UIStateBox.forModel(self, key: FileTreeModel.projectUIStateKey).state
		}
		set {
			UIStateBox.forModel(self, key: FileTreeModel.projectUIStateKey).state	=	newValue
			Notification(self, UIState.Event.Invalidate).broadcast()
		}
	}



	///

	private static let	projectUIStateKey	=	UIStateKey()
}
















































