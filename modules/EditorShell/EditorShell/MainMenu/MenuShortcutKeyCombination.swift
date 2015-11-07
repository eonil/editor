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
///	Take care that `plainTextKeys` part is case sensitive. Anyawy,
///	it will be converted into lowercase string if you're creating 
///	it using operators. If you want to express `Shift`, use `Shift`
///	explicitly.
///
struct MenuShortcutKeyCombination {
	static let Command	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: true, controlModifier: false, alternateModifier: false, shiftModifier: false)
	static let Control	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, controlModifier: true, alternateModifier: false, shiftModifier: false)
	static let Alternate	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, controlModifier: false, alternateModifier: true, shiftModifier: false)
	static let Shift	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, controlModifier: false, alternateModifier: false, shiftModifier: true)

	

	init(legacyUTF16CodeUnit: unichar) {
		self	=	MenuShortcutKeyCombination(String(utf16CodeUnits: [legacyUTF16CodeUnit], count: 1))
	}
	init(_ plainTextKeys: String) {
		self.plainTextKeys	=	plainTextKeys
		self.commandModifier	=	false
		self.controlModifier	=	false
		self.alternateModifier	=	false
		self.shiftModifier	=	false
	}
	init(plainTextKeys: String, commandModifier: Bool, controlModifier: Bool, alternateModifier: Bool, shiftModifier: Bool) {
		self.plainTextKeys	=	plainTextKeys
		self.commandModifier	=	commandModifier
		self.controlModifier	=	controlModifier
		self.alternateModifier	=	alternateModifier
		self.shiftModifier	=	shiftModifier
	}

	var	plainTextKeys		:	String
	var	commandModifier		:	Bool
	var	controlModifier		:	Bool
	var	alternateModifier	:	Bool
	var	shiftModifier		:	Bool
	
	var modifierMask: UInt {
		get {
			return	(commandModifier ? NSEventModifierFlags.CommandKeyMask.rawValue : 0)
			|	(controlModifier ? NSEventModifierFlags.ControlKeyMask.rawValue : 0)
			|	(alternateModifier ? NSEventModifierFlags.AlternateKeyMask.rawValue : 0)
			|	(shiftModifier ? NSEventModifierFlags.ShiftKeyMask.rawValue : 0)
		}
	}

	static let None	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, controlModifier: false, alternateModifier: false, shiftModifier: false)

}


func + (left:MenuShortcutKeyCombination, right:MenuShortcutKeyCombination) -> MenuShortcutKeyCombination {
	return	MenuShortcutKeyCombination(
		plainTextKeys		:	left.plainTextKeys + right.plainTextKeys,
		commandModifier		:	left.commandModifier || right.commandModifier,
		controlModifier		:	left.controlModifier || right.controlModifier,
		alternateModifier	:	left.alternateModifier || right.alternateModifier,
		shiftModifier		:	left.shiftModifier || right.shiftModifier)
}
func + (left:MenuShortcutKeyCombination, right:String) -> MenuShortcutKeyCombination {
	var	s	=	left
	s.plainTextKeys	+=	right.lowercaseString
	return	s
}

extension NSMenuItem {
	convenience init(title:String, shortcut:MenuShortcutKeyCombination, availability:Bool = false) {
		self.init()
		self.title			=	title
		self.keyEquivalent		=	shortcut.plainTextKeys
		self.keyEquivalentModifierMask	=	Int(bitPattern: shortcut.modifierMask)
		self.enabled			=	availability
	}
}






