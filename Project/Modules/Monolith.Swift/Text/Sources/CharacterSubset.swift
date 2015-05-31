//
//  CharacterSubset.swift
//  EDXC
//
//  Created by Hoon H. on 10/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


///	Defines a subset of characters.
public struct CharacterSubset {
	public typealias	Test	=	Character -> Bool
	
	public static func or(cs:[Test])(character ch:Character) -> Bool {
		for c in cs {
			if c(ch) {
				return	true
			}
		}
		return	false
	}
	public static func not(c:Test)(character ch:Character) -> Bool {
		return	c(ch) == false
	}
	public static func any(chs:[Character])(character ch:Character) -> Bool {
		return	contains(chs, ch)
	}
	public static func one(ch1:Character)(character ch2:Character) -> Bool {
		return	ch1 == ch2
	}
}

