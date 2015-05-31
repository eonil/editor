//
//  Cursor.swift
//  EDXC
//
//  Created by Hoon H. on 10/13/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


final class Code {
	
	let	data:String
	
	init(data:String) {
		self.data	=	data
	}
	
}

///	Oneway directed cursor.
public struct Cursor {
	let	code:Code
	let	location:String.Index
	
	var available:Bool {
		get {
			return	location < code.data.endIndex
		}
	}
	
	///	Crashes if not `available`.
	var current:Character {
		get {
			precondition(available)
			
			return	code.data[location]
		}
	}
	
	var continuation:Cursor {
		get {
			precondition(available)
			
			return	stepping()
		}
	}
	
	func contains(character ch:Character) -> Bool {
		precondition(available)
		
		return	available && code.data[location] == ch
	}
	func contains(string s:String) -> Bool {
		precondition(available)
		
		return	s.startIndex == s.endIndex || (contains(character: s[s.startIndex]) && stepping().contains(string: s.substringFromIndex(s.startIndex.successor())))
	}
	func stepping() -> Cursor {
		precondition(available)
		
		return	Cursor(code: code, location: location.successor())
	}
	func stepping(by c1:Int) -> Cursor {
		precondition(available)
		
		return	c1 == 0 ? self : stepping(by: c1 - 1)
	}
	func stepping(byLengthOfString s:String) -> Cursor {
		precondition(available)
		
		return	s.startIndex == s.endIndex ? self : stepping(byLengthOfString: s.substringFromIndex(s.startIndex.successor()))
	}
	
	func content(from c1:Cursor) -> String {
		return	c1.content(to: self)
	}
	func content(to c1:Cursor) -> String {
		precondition(self < c1)
		
		let	r1	=	location..<c1.location
		let	s1	=	code.data[r1]
		return	s1
	}
}


extension Cursor : Printable {
	public var description:String {
		get {
			return	"Cursor (code Code @) (location String.Index \(location))"
		}
	}
}










func == (left:Cursor, right:Cursor) -> Bool {
	return	left.location == right.location
}
func < (left:Cursor, right:Cursor) -> Bool {
	return	left.location < right.location
}
func > (left:Cursor, right:Cursor) -> Bool {
	return	left.location < right.location
}
func <= (left:Cursor, right:Cursor) -> Bool {
	return	left.location <= right.location
}
func >= (left:Cursor, right:Cursor) -> Bool {
	return	left.location >= right.location
}

