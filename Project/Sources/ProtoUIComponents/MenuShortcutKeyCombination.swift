//
//  MenuShortcutKeyCombination.swift
//  Editor
//
//  Created by Hoon H. on 2015/02/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

///	Provides easier way to combine `keyEquivalent` for `NSMenuItem`.
///	
///	Example:
///
///	In a `MenuController` subclass,
///
///		Command+"A"
///
///	See `WorkspaceDebuggingController.swift` file for full usage.
struct MenuShortcutKeyCombination {
	var	plainTextKeys:String
	var	commandModifier:Bool
	var	alternateModifier:Bool
	var	shiftModifier:Bool
	
	var modifierMask: Int {
		get {
			return
				(commandModifier ? Int(bitPattern: NSEventModifierFlags.CommandKeyMask.rawValue) : 0) |
				(alternateModifier ? Int(bitPattern: NSEventModifierFlags.AlternateKeyMask.rawValue) : 0) |
				(shiftModifier ? Int(bitPattern: NSEventModifierFlags.ShiftKeyMask.rawValue) : 0)
		}
	}
}


func + (left:MenuShortcutKeyCombination, right:MenuShortcutKeyCombination) -> MenuShortcutKeyCombination {
	return	MenuShortcutKeyCombination(plainTextKeys: left.plainTextKeys + right.plainTextKeys, commandModifier: left.commandModifier || right.commandModifier, alternateModifier: left.alternateModifier || right.alternateModifier, shiftModifier: left.shiftModifier || right.shiftModifier)
}
func + (left:MenuShortcutKeyCombination, right:String) -> MenuShortcutKeyCombination {
	var	s	=	left
	s.plainTextKeys		+=	right
	return	s
}

extension MenuController {
	static let Command		=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: true, alternateModifier: false, shiftModifier: false)
	static let Alternate	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, alternateModifier: true, shiftModifier: false)
	static let Shift		=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, alternateModifier: false, shiftModifier: true)
	static let None			=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, alternateModifier: false, shiftModifier: false)
}

extension NSMenuItem {
	convenience init(title:String, shortcut:MenuShortcutKeyCombination, availability:Bool = false) {
		self.init()
		self.title						=	title
		self.keyEquivalent				=	shortcut.plainTextKeys
		self.keyEquivalentModifierMask	=	shortcut.modifierMask
		self.enabled					=	availability
	}
}







