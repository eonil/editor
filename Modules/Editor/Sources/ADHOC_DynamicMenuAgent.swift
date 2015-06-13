//
//  ADHOC_DynamicMenuAgent.swift
//  Editor
//
//  Created by Hoon H. on 2015/06/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorMenuUI

class ADHOC_DynamicMenuAgent {
	init() {
		NSNotificationCenter.defaultCenter().addObserverForName(NSWindowDidBecomeKeyNotification,
			object:	nil,
			queue: 	NSOperationQueue.mainQueue()) { [weak self] (n: NSNotification!) -> Void in
				assert(n.object is NSWindow)
				let	window	=	n.object as! NSWindow
				let	doccon	=	NSDocumentController.sharedDocumentController() as! NSDocumentController
				if let wsdoc = doccon.documentForWindow(window) as? WorkspaceDocument {
					self?.project.workspace		=	wsdoc.model
					self?.debug.workspace		=	wsdoc.model
				}
		}
		NSNotificationCenter.defaultCenter().addObserverForName(NSWindowDidResignKeyNotification,
			object:	nil,
			queue: 	NSOperationQueue.mainQueue()) { [weak self] (n: NSNotification!) -> Void in
				assert(n.object is NSWindow)
				let	window	=	n.object as! NSWindow
				let	doccon	=	NSDocumentController.sharedDocumentController() as! NSDocumentController
				if let wsdoc = doccon.documentForWindow(window) as? WorkspaceDocument {
					assert(self?.project.workspace === wsdoc.model)
					assert(self?.debug.workspace === wsdoc.model)
					self?.project.workspace		=	nil
					self?.debug.workspace		=	nil
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
