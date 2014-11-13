//
//  Internals.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation










extension String {
	func findRangeOfLineContentAtIndex(lineIndex:Int) -> Range<String.Index>? {
		var	counter					=	0
		var	currentCapturingRange	=	self.startIndex..<self.endIndex
		let	options					=	NSStringEnumerationOptions.ByLines | NSStringEnumerationOptions.SubstringNotRequired
		var	resultingSubstringRange	=	nil as Range<String.Index>?
		self.enumerateSubstringsInRange(currentCapturingRange, options: options) { (substring:String!, substringRange, enclosingRange, inout stop:Bool) -> () in
			if counter == lineIndex {
				resultingSubstringRange	=	substringRange
				stop	=	true
			}
			counter++
		}
		return	resultingSubstringRange
	}
}

//extension Array {
//	mutating func removeAllValueEqualsToValue(value:Element) {
//		self	=	self.filter({$0 != value})
//	}
//}





infix operator >>> {
associativity left
}
infix operator <<< {
associativity left
}

func >>> <T,U> (v:T, f:T->U) -> U {
	return	f(v)
}
func <<< <T,U> (f:T->U, v:T) -> U {
	return	f(v)
}











@noreturn
func unreachableCodeError() {
	fatalError("This code path should be unreachable.")
}


















































