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
public struct UIState {
	public static func initiate() {
		assert(_isReady == false)
		WorkspaceModel.Event.Notification.register(self, _process)
		_isReady	=	true
		Debug.log("UIState.initiate")
	}
	public static func terminate() {
		assert(_isReady == true)
		WorkspaceModel.Event.Notification.deregister(self)
		_isReady	=	false
		Debug.log("UIState.terminate")
	}





	///

	public enum Event {
		case Initiate
		case Invalidate
		case Terminate
	}









	///

	public enum ForWorkspaceModel {
		public typealias	Notification	=	EditorModel.Notification<WorkspaceModel, Event>

		public static func get(m: WorkspaceModel, @noescape process: (state: WorkspaceUIState) -> ()) {
			assert(_isReady == true, "You must `initialize` this struct before using.")
			assert(_workspaceToState[identityOf(m)] != nil, "Cannot find UI state for model `\(m)`.")
			process(state: _workspaceToState[identityOf(m)]!)
		}
		/// Fires a `Notification<WorkspaceModel,UIState.Event>` after state change.
		public static func set(m: WorkspaceModel, @noescape process: (inout state: WorkspaceUIState) -> ()) {
			assert(_isReady == true, "You must `initialize` this struct before using.")
			assert(_workspaceToState[identityOf(m)] != nil, "Cannot find UI state for model `\(m)`.")
			process(state: &_workspaceToState[identityOf(m)]!)
			Notification(m, Event.Invalidate).broadcast()
		}
	}







	///

	private static var	_isReady		=	false
	private static var	_workspaceToState	=	Dictionary<ReferentialIdentity<WorkspaceModel>, WorkspaceUIState>()

	private static func _process(n: WorkspaceModel.Event.Notification) {
		switch n.event {
		case .DidInitiate:
			assert(_workspaceToState[identityOf(n.sender)] == nil)
			_workspaceToState[identityOf(n.sender)]	=	WorkspaceUIState()
			Notification(n.sender,Event.Initiate).broadcast()
		case .WillTerminate:
			assert(_workspaceToState[identityOf(n.sender)] != nil)
			Notification(n.sender,Event.Terminate).broadcast()
			_workspaceToState[identityOf(n.sender)]	=	nil
		default:
			break
		}
	}
}






public struct WorkspaceUIState {
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
















