//
//  UIProtocols.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/10/25.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon
import EditorModel

//public protocol ApplicationUIDelegate {
//	func applicationUIDidChangeCurrentWorkspace(_: ApplicationUIProtocol)
//}
public protocol ApplicationUIProtocol: class {
//	var currentWorkspaceUI: WorkspaceUIProtocol? { get }
	var currentWorkspaceUI2: ValueStorage2<WorkspaceUIProtocol?> { get }
}
public protocol WorkspaceUIProtocol: class {
	weak var model: WorkspaceModel? { get }
}






//public protocol MenuItemUIProtocol: class {
//	var enabled: Bool { get set }
//}
//
//public protocol FileMenuUIProtocol: class {
//	var new: FileNewMenuUIProtocol { get }
//}
//public protocol FileNewMenuUIProtocol: class {
//	var workspace: MenuItemUIProtocol { get }
//}
//











