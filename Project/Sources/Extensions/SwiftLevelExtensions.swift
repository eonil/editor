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
extension String {
	public func convertRangeToNSRange(r:Range<String.Index>) -> NSRange {
		let a   =   substringToIndex(r.startIndex)
		let b   =   substringWithRange(r)
		
		return  NSRange(location: a.utf16Count, length: b.utf16Count)
	}
	
	
	///	O(1) if `self` is optimised to use UTF-16.
	///	O(n) otherwise.
	public func convertRangeToNSRange(r:Range<String.UnicodeScalarView.Index>) -> NSRange {
		let	a	=	convertIndexToNSStringLocationIndex(r.startIndex)
		let	b	=	convertIndexToNSStringLocationIndex(r.endIndex)
		
		return	NSRange(location: a, length: b-a)
	}
	
	///	O(1) if `self` is optimised to use UTF-16.
	///	O(n) otherwise.
	public func convertIndexToNSStringLocationIndex(i:String.UnicodeScalarView.Index) -> NSInteger {
		return	convertIndexToUTF16CodeUnitIndex(i)
	}
	
	///	O(1) if `self` is optimised to use UTF-16.
	///	O(n) otherwise.
	public func convertIndexToUTF16CodeUnitIndex(i:String.UnicodeScalarView.Index) -> Int {
		let	v	=	unicodeScalars
		//	`String` is `NSString` and `NSString` is likely to make subrange view instead of copying the content.
		return	String(v[v.startIndex..<i]).utf16Count
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


















































