//
//  MenuControllers.swift
//  Editor
//
//  Created by Hoon H. on 2015/02/20.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorUIComponents

//
//	Dynamic Menus
//	-------------
//
//	`ApplicationController` is responsible to manage dynamic state of all menus.
//	See implementation of the class for details.
//


///
///	MARK:	Dynamic Menus
///	MARK:	-
///



class ProjectMenuController: MenuController {
	let	run			=	NSMenuItem(title: "Run", shortcut: Command+"r")
	let	test		=	NSMenuItem(title: "Test", shortcut: Command+"u")
	let	documentate	=	NSMenuItem(title: "Documentate", shortcut: None)
	let	benchmark	=	NSMenuItem(title: "Benchmark", shortcut: None)
	
	let	build		=	NSMenuItem(title: "Build", shortcut: Command+"b")
	let	clean		=	NSMenuItem(title: "Clean", shortcut: Command+Shift+"k")
	let	stop		=	NSMenuItem(title: "Stop", shortcut: Command+".")
	
	init() {
		let	m	=	NSMenu()
		m.autoenablesItems	=	false
		m.title				=	"Project"
		m.allMenuItems	=	[
			run,
			test,
			documentate,
			benchmark,
			NSMenuItem.separatorItem(),
			build,
			clean,
			stop,
		]
		super.init(m)
	}
}

final class DebugMenuController: MenuController {
	let	stepOver	=	NSMenuItem(title: "Step Over", shortcut: Command+"1")
	let	stepInto	=	NSMenuItem(title: "Step Into", shortcut: Command+"2")
	let	stepOut		=	NSMenuItem(title: "Step Out", shortcut: Command+"3")
	
	init() {
		let	m	=	NSMenu()
		m.autoenablesItems	=	false
		m.title				=	"Debug"
		m.allMenuItems		=	[
			stepOver,
			stepInto,
			stepOut,
		]
		super.init(m)
	}
}