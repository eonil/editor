//
//  MenuControllers.swift
//  Editor
//
//  Created by Hoon H. on 2015/02/20.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit


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



final class ProjectMenuController: MenuController {
	let	build	=	NSMenuItem(title: "Build", shortcut: Command+"B")
	let	run		=	NSMenuItem(title: "Run", shortcut: Command+"R")
	let	clean	=	NSMenuItem(title: "Clean", shortcut: Command+Shift+"K")
	let	stop	=	NSMenuItem(title: "Stop", shortcut: Command+".")
	
	init() {
		let	m	=	NSMenu()
		m.autoenablesItems	=	false
		m.title				=	"Project"
		m.allMenuItems	=	[
			build,
			run,
			clean,
			NSMenuItem.separatorItem(),
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