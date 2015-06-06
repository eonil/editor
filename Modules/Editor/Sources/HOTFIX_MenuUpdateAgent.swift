//
//  HOTFIX_MenuUpdateAgent.swift
//  Editor
//
//  Created by Hoon H. on 2015/06/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorMenuUI

class HOTFIX_MenuUpdateAgent {
	init() {
		let	name	=	NSWindowDidBecomeKeyNotification
		let	q	=	NSOperationQueue.mainQueue()
		NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: q) { [weak self] (n: NSNotification!) -> Void in
			assert(n.object is NSWindow)
			let	window	=	n.object as! NSWindow
			let	doccon	=	NSDocumentController.sharedDocumentController() as! NSDocumentController
			if let wsdoc = doccon.documentForWindow(window) as? WorkspaceDocument {
				self?.project.workspace		=	wsdoc.model
				self?.debug.workspace		=	wsdoc.model
			}
		}
	}
	
	var	projectMenu: NSMenu {
		get {
			return	project.menu
		}
	}
	
	var	debugMenu: NSMenu {
		get {
			return	debug.menu
		}
	}
	
	///
	
	private let	project		=	ProjectMenuController()
	private let	debug		=	DebugMenuController()
}