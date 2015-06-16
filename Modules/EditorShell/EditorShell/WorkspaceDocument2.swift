//
//  WorkspaceDocument2.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

public class WorkspaceDocument2: NSDocument {
	
	override init() {
		_mainWindowController.shell	=	_shell
	}
	deinit {
		_mainWindowController.shell	=	nil
	}
	
	public override func makeWindowControllers() {
		super.makeWindowControllers()
		addWindowController(_mainWindowController)
		_mainWindowController.showWindow(self)
	}
	public override func readFromURL(url: NSURL, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		return	true
	}
	
	///
	
	private let	_shell			=	Shell()
	private let	_mainWindowController	=	WorkspaceMainWindowController()
}