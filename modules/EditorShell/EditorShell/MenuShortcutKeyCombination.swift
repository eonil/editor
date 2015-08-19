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
	var	plainTextKeys:String
	var	commandModifier:Bool
	var	alternateModifier:Bool
	var	shiftModifier:Bool
	
	var modifierMask: UInt {
		get {
			return	(commandModifier ? NSEventModifierFlags.CommandKeyMask.rawValue : 0)
			|	(alternateModifier ? NSEventModifierFlags.AlternateKeyMask.rawValue : 0)
			|	(shiftModifier ? NSEventModifierFlags.ShiftKeyMask.rawValue : 0)
		}
	}

	static let None	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, alternateModifier: false, shiftModifier: false)

}


func + (left:MenuShortcutKeyCombination, right:MenuShortcutKeyCombination) -> MenuShortcutKeyCombination {
	return	MenuShortcutKeyCombination(plainTextKeys: left.plainTextKeys + right.plainTextKeys, commandModifier: left.commandModifier || right.commandModifier, alternateModifier: left.alternateModifier || right.alternateModifier, shiftModifier: left.shiftModifier || right.shiftModifier)
}
func + (left:MenuShortcutKeyCombination, right:String) -> MenuShortcutKeyCombination {
	var	s	=	left
	s.plainTextKeys	+=	right.lowercaseString
	return	s
}

let Command	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: true, alternateModifier: false, shiftModifier: false)
let Alternate	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, alternateModifier: true, shiftModifier: false)
let Shift	=	MenuShortcutKeyCombination(plainTextKeys: "", commandModifier: false, alternateModifier: false, shiftModifier: true)

extension NSMenuItem {
	convenience init(title:String, shortcut:MenuShortcutKeyCombination, availability:Bool = false) {
		self.init()
		self.title			=	title
		self.keyEquivalent		=	shortcut.plainTextKeys
		self.keyEquivalentModifierMask	=	Int(bitPattern: shortcut.modifierMask)
		self.enabled			=	availability
	}
}






