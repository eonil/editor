//
//  MenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

public class MenuController {

	public var menu: NSMenu {
		get {
			return	_menu
		}
	}

	///

	private let	_menu		=	NSMenu()

	private let	_file		=	FileMenuController()
	private let	_product	=	ProductMenuController()
	private let	_debug		=	DebugMenuController()
}





class FileMenuController {

}

class ProductMenuController {

}

class DebugMenuController {

}