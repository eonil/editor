////
////  UIModel.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/11/07.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import EditorCommon
//import EditorModel
//
//
//
//
//
//protocol UIModelType {
//	typealias Event
//}
//extension UIModelType {
//	func broadcast(event: Event) {
//		Notification(self, event).broadcast()
//	}
//}
//
//
//
//
//
//class ApplicationUIModel: UIModelType {
//	enum Event {
//	}
//
//
//
//	///
//
//	init() {
//		ApplicationModel.Event.Notification.register(self, ApplicationUIModel._process)
//	}
//	deinit {
//		ApplicationModel.Event.Notification.deregister(self)
//	}
//
//
//
//
//	///
//
//	func workspaceForModel(m: WorkspaceModel) -> WorkspaceUIModel {
//		return	_map[identityOf(m)]!
//	}
//	func addWorkspaceForModel(m: WorkspaceModel) {
//		_map[identityOf(m)]	=	WorkspaceUIModel()
//	}
//	func removeWorkspaceForModel(m: WorkspaceModel) {
//		_map[identityOf(m)]	=	nil
//	}
//
//
//
//	///
//
//	private var	_map	=	Dictionary<ReferentialIdentity<WorkspaceModel>, WorkspaceUIModel>()
//
//	private func _process(n: ApplicationModel.Event.Notification) {
//		switch n.event {
//		case .DidAddWorkspace(let ws):
//			addWorkspaceForModel(ws)
//		case .WillRemoveWorkspace(let ws):
//			removeWorkspaceForModel(ws)
//		default:
//			break;
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
//struct UIState {
//	struct OfWorkspaceUI {
//		var navigationPaneVisibility: Bool
//		var inspectionPaneVisibility: Bool
//		var consolePaneVisibility: Bool
//
//
//
//
//		///
//
//		static func initialize() {
//
//		}
//		static func terminate() {
//
//		}
//		static func forWorkspaceModel(m: WorkspaceModel, process: (inout _: OfWorkspaceUI)->()) {
//			process(&_workspaceToState[identityOf(m)]!)
//		}
//
//
//		static var	_workspaceToState	=	Dictionary<ReferentialIdentity<WorkspaceModel>, OfWorkspaceUI>()
//	}
//}
//
//class WorkspaceUIModel: UIModelType {
//	enum Event {
//		case Invalidate
//	}
//
//
//
//
//	///
//
//	weak var applicationUIModel: ApplicationUIModel?
//
//	static func forDataModel(dataModel: WorkspaceModel) -> WorkspaceUIModel {
//		return
//	}
//
//
//
//	///
//
//	var navigationPaneVisibility: Bool = false {
//		didSet {
//			broadcast(.Invalidate)
//		}
//	}
//
//	var inspectionPaneVisibility: Bool = false {
//		didSet {
//			broadcast(.Invalidate)
//		}
//	}
//
//	var consolePaneVisibility: Bool = false {
//		didSet {
//			broadcast(.Invalidate)
//		}
//	}
//	
//}
//
//
//
//
//
//
//
//
