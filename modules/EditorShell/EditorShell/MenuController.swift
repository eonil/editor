//
//  MenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorUICommon
import EditorModel

public class MainMenuController: SessionProtocol {

	public weak var model: ApplicationModel? {
		willSet {
			assert(_isRunning == false)
		}
		didSet {
			_file.model	=	model
			_product.model	=	model
			_debug.model	=	model
		}
	}

	///

	public init() {
		_topItems	=	[
			_file.menu,
			_product.menu,
			_debug.menu,
		]
	}

	///

	public var topLevelMenus: [NSMenu] {
		get {
			return	_topItems
		}
	}
	public func run() {
		assert(model != nil)
		for s in _allSessionObjects() {
			s.run()
		}
	}
	public func halt() {
		assert(model != nil)
		for s in _allSessionObjects() {
			s.halt()
		}
	}

	///

	private let	_topItems	:	[TopLevelCommandMenu]

	private let	_file		=	FileMenuController()
	private let	_product	=	ProductMenuController()
	private let	_debug		=	DebugMenuController()

	private var	_isRunning	=	false

	private func _allSessionObjects() -> [SessionProtocol] {
		return	[
			_file,
			_product,
			_debug,
		]
	}
}






class DebugMenuController: SessionProtocol {

	weak var model: ApplicationModel?

	///

	init() {
		menu	=
			_topLevelMenu("Debug", items: [
				pause,
				resume,
				stop,
				_menuSeparatorItem(),
				stepInto,
				stepOut,
				stepOver,
				])

	}

	///

	let	menu		:	TopLevelCommandMenu
	let	pause		=	_menuItem("Pause", 	.Debugging(.Pause))
	let	resume		=	_menuItem("Resume",	.Debugging(.Resume))
	let	stop		=	_menuItem("Halt",	.Debugging(.Halt))
	let	stepInto	=	_menuItem("Step Into",	.Debugging(.StepInto))
	let	stepOut		=	_menuItem("Step Out",	.Debugging(.StepOut))
	let	stepOver	=	_menuItem("Step Over",	.Debugging(.StepOver))

	func run() {

	}
	func halt() {

	}
}











































