//
//  WorkspaceDocument2.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel

public class WorkspaceDocument2: NSDocument {
	
	internal override init() {
		_mainWindowController.shell	=	_shell
	}
	deinit {
		_mainWindowController.shell	=	nil
	}
	
	///	You should not read this before finish reading a data from a URL.
	public var model: Workspace {
		get {
			return	_workspace!
		}
	}
	
	public override func makeWindowControllers() {
		super.makeWindowControllers()
		addWindowController(_mainWindowController)
		_mainWindowController.showWindow(self)
	}
	public override func readFromURL(url: NSURL, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		assert(url.pathExtension == "eeworkspace" || url.pathExtension == "workspace")
		_workspace	=	Workspace(rootDirectoryURL: url)
		return	true
	}
	
	///
	
	private let	_shell			=	Shell()
	private let	_mainWindowController	=	WorkspaceMainWindowController()
	
	private var	_workspace		:	Workspace?
}