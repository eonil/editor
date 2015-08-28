////
////  SelectionModel2.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/22.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
///// Provides flat, always-ready interface for current selections 
///// over nodes in application model tree
/////
///// This is just a wrapped interface to model nodes. All selected
///// nodes are all indirect access to "default node" of each nodes.
/////
//public class SelectionModel2: ModelSubnode<ApplicationModel> {
//
//	public var application: ApplicationModel {
//		get {
//			return	owner!
//		}
//	}
//
//	public override func didJoinModelRoot() {
//		super.didJoinModelRoot()
//		workspace.originStorage		=	application.currentWorkspace
//		workspace.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//			self?.debuggingTarget.originStorage	=	self?.workspace.value?.debug.currentTarget
//		}
//		workspace.registerWillSet(ObjectIdentifier(self)) { [weak self] in
//			self?.debuggingTarget.originStorage	=	nil
//		}
//		debuggingTarget.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//			print(self?.debuggingTarget.value)
//		}
//		debuggingTarget.registerWillSet(ObjectIdentifier(self)) { [weak self] in
//			print(self?.debuggingTarget.value)
//		}
//	}
//	public override func willLeaveModelRoot() {
//		debuggingTarget.deregisterWillSet(ObjectIdentifier(self))
//		debuggingTarget.deregisterDidSet(ObjectIdentifier(self))
//		workspace.deregisterWillSet(ObjectIdentifier(self))
//		workspace.deregisterDidSet(ObjectIdentifier(self))
//		workspace.originStorage		=	nil
//		super.willLeaveModelRoot()
//	}
//
//	///
//
//	public let	workspace		=	SwitchableValueStorage<WorkspaceModel>()
//	public let	debuggingTarget		=	SwitchableValueStorage<DebuggingTargetModel>()
//}
//
//extension SelectionModel2 {
////	func switchToWorkspace(workspace: WorkspaceModel) {
////	}
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
