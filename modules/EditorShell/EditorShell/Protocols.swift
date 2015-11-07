////
////  Protocols.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/11/05.
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
//
////// Keep in mind that the views are composition of "input" and "output".
////// Separate them clearly.
////
//
//
//protocol ApplicationUIProtocol: class {
//	var currentWorkspaceWindowUI: WorkspaceWindowUIProtocol? { get }
//	func workspaceWindowUIForWorkspaceModel(model: WorkspaceModel) -> WorkspaceWindowUIProtocol
//}
//protocol WorkspaceWindowUIProtocol: class {
//	weak var applicationUI: ApplicationUIProtocol? { get }
//	var paneDivisionUI: PaneDivisionUIProtocol { get }
//	var toolUI: ToolUIProtocol { get }
//
//	var navigationPaneVisibility: Bool { get set }
//	var inspectionPaneVisibility: Bool { get set }
//	var consolePaneVisibility: Bool { get set }
//}
//
//protocol PaneDivisionUIProtocol: class {
////	weak var workspaceWindowUI: WorkspaceWindowUIProtocol? { get }
//}
////
//protocol ToolUIProtocol: class {
////	weak var workspaceWindowUI: WorkspaceWindowUIProtocol? { get }
//}
//
//
//
////
////
////protocol UIComponentType: UIComponentProtocol {
////	typealias	State
////	var state: State { get set }
////}
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
//
//
