//
//  UIProtocols.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/10/25.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorModel

//public protocol ApplicationUIDelegate {
//	func applicationUIDidChangeCurrentWorkspace(_: ApplicationUIProtocol)
//}
public protocol ApplicationUIProtocol: class {
	var currentWorkspaceUI: WorkspaceUIProtocol? { get }
}
public protocol WorkspaceUIProtocol: class {
	weak var model: WorkspaceModel? { get }
}