////
////  SelectionModel.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/22.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import MulticastingStorage
//
///// Provides a flat, singular selection repository.
/////
///// Selection information can be exist in each model node,
///// but it's incredibly hard to use because we need to track
///// all the intermediate nodes to get a leaf selection value.
///// That's why we need a **flat** selection repository. By 
///// using this one, you can watch each selection value in a
///// one step without tracking deep nodes.
///// 
///// This does not "replace" exisitng "current" selection value
///// in each nodes. They still there because we need to keep
///// selection for each node so we can restore selection when 
///// switcing selections of thier supernodes.
/////
///// This is an higher level structure than each model node.
///// Tracking selection for each nodes are done in this object,
///// by monitoring selections of them. Each model nodes do
///// not access to this object.
/////
///// When you represent "user selection", you must use this 
///// object instead of "current" objects of each nodes. Because
///// this selection is switched by watching them, order 
///// dependency between them are undefined.
/////
///// When selecting a node, you usually need to deselect all
///// selections of subnodes. Anyway this is not required, and
///// a rule that is applied always.
/////
///// `select~/deselect~` methods handles only that node, and
///// it would be hard to satisfy requirements of them. You can
///// use `switchTo~` method series that handles suchs thing 
///// automatically.
/////
//public class SelectionModel: ModelSubnode<ApplicationModel> {
//
//	public var application: ApplicationModel {
//		get {
//			return	owner!
//		}
//	}
//
//	///
//
//	/// Current `workspace` must be `nil`.
//	/// Current `debuggingTarget` must be `nil`.
//	public func selectWorkspace(workspace: WorkspaceModel) {
//		assert(_debuggingTarget.value == nil)
//		assert(_workspace.value == nil)
//		_workspace.value	=	workspace
//	}
//	/// Current `workspace` must be non-`nil`.
//	/// Current `debuggingTarget` must be `nil`.
//	public func deselectWorkspace() {
//		assert(_debuggingTarget.value == nil)
//		assert(_workspace.value != nil)
//		_workspace.value	=	nil
//	}
//
//	/// Current `debuggingTarget` must be `nil`.
//	public func selectDebuggingTarget(target: DebuggingTargetModel) {
//		assert(_debuggingTarget.value == nil)
//		_debuggingTarget.value	=	target
//	}
//	/// Current `debuggingTarget` must be non-`nil`.
//	public func deselectDebuggingTarget() {
//		assert(_debuggingTarget.value != nil)
//		_debuggingTarget.value	=	nil
//	}
//
//	///
//
//	private let	_workspace		=	MutableValueStorage<WorkspaceModel?>(nil)
//	private let	_debuggingTarget	=	MutableValueStorage<DebuggingTargetModel?>(nil)
//
//}
//
//public extension SelectionModel {
//
//	public func switchToWorkspace(workspace: WorkspaceModel?) {
//		guard workspace !== _workspace.value else {
//			return
//		}
//
//		///
//
//		if let workspace = workspace {
//			if let _ = workspace.debug.currentTarget.value {
//				deselectDebuggingTarget()
//			}
//			deselectWorkspace()
//		}
//		if let workspace = workspace {
//			selectWorkspace(workspace)
//			if let t = workspace.debug.currentTarget.value {
//				selectDebuggingTarget(t)
//			}
//		}
//	}
//
//	/// Also switches workspace that owns the target if the workspace
//	/// is not yet selected.
//	public func switchToTarget(target: DebuggingTargetModel?) {
//		guard target !== _debuggingTarget.value else {
//			return
//		}
//
//		///
//
//		assert(target == nil || target!.debugging.workspace === _workspace.value)
//
//		if let target = target {
//			deselectDebuggingTarget()
//			if target.debugging.workspace !== _workspace.value {
//				deselectWorkspace()
//			}
//		}
//		if let target = target {
//			if target.debugging.workspace !== _workspace.value {
//				selectWorkspace(target.debugging.workspace)
//			}
//			selectDebuggingTarget(target)
//		}
//	}
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
//
//
//
//
//
