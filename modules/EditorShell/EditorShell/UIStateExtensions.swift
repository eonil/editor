//
//  UIStateExtensions.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/16.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorModel
import EditorUICommon


public extension UIState {
	public struct ForApplicationModel {
		public typealias	Notification	=	EditorModel.Notification<ApplicationModel, Event>
	}
}

public extension ApplicationModel {
//	public var currentWorkspace: WorkspaceModel? {
//		get {
//			return	_currentWorkspace
//		}
//		set {
//			_currentWorkspace	=	newValue
//			UIState.ForApplicationModel.Notification(self, .Invalidate).broadcast()
//		}
//	}


//	public var currentWorkspace: WorkspaceModel? {
//		get {
//			func getCurrentWorkspace() -> WorkspaceModel? {
//				guard let window = NSApplication.sharedApplication().mainWindow else {
//					return	nil
//				}
//				guard let workspaceWindowController = window.windowController as? WorkspaceWindowUIController else {
//					return	nil
//				}
//				// A dead UI component can susive a little longer than model object.
//				// At this point, workspace model is fully removed from model tree,
//				// and it should be treated like non-existent.
//				guard let workspace = workspaceWindowController.model else {
//					return	nil
//				}
//				return	workspace
//			}
//			return	getCurrentWorkspace()
//		}
//		set {
//			markUnimplemented()
//		}
//	}

}















//private func _findUIForModel(workspace: WorkspaceModel) -> (document: WorkspaceDocument, windowController: WorkspaceWindowUIController)? {
//	for doc in NSDocumentController.sharedDocumentController().documents {
//		if let doc = doc as? WorkspaceDocument {
//			for wc in doc.windowControllers {
//				if let wc = wc as? WorkspaceWindowUIController {
//					return	(doc, wc)
//				}
//			}
//		}
//	}
//	return	nil
//}










//private var _currentWorkspace: WorkspaceModel?