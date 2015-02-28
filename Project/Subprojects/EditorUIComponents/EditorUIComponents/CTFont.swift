//
//  CTFont.swift
//  EditorUIComponents
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation



extension CTFont {
	static func withName(name:String, size:CGFloat) -> CTFont {
		return	CTFontCreateWithName(name, size, nil)!
	}
	
	func fontWithSize(size:CGFloat) -> CTFont {
		return	CTFont.withName(self.fullName, size: size)
	}
}

extension CTFont {
	var fullName:String {
		get {
			return	CTFontCopyFullName(self)! as NSString as String
		}
	}
	var size:CGFloat {
		get {
			return	CTFontGetSize(self)
		}
	}
	var matrix:CGAffineTransform {
		get {
			return	CTFontGetMatrix(self)
		}
	}
	var	ascent:CGFloat {
		get {
			return	CTFontGetAscent(self)
		}
	}
	var	descent:CGFloat {
		get {
			return	CTFontGetDescent(self)
		}
	}
	var leading:CGFloat {
		get {
			return	CTFontGetLeading(self)
		}
	}
}

extension CTFont {
	func glyphsForCharacters(characters:String) -> [CGGlyph] {
		let	s2		=	characters as NSString
		var	a1		=	[] as [unichar]
		for i in 0..<s2.length {
			a1.append(s2.characterAtIndex(i))
		}
		
		return	a1.withUnsafeBufferPointer { (p:UnsafeBufferPointer<unichar>) -> [CGGlyph] in
			let	num	=	count(characters.utf16)
			let	p1	=	UnsafeMutablePointer<CGGlyph>.alloc(num)	//	Glyph must be smaller than UTF-16 code-unit count.
			let	ok	=	CTFontGetGlyphsForCharacters(self, p.baseAddress, p1, CFIndex(a1.count))
			
			precondition(ok)
			let	gs	=	copyMemoryToArray(p1, num)
			p1.dealloc(num)
			return	gs
		}
	}
	func boundingRectsForGlyphs(glyphs:[CGGlyph], orientation:CTFontOrientation) -> (items:[CGRect], union:CGRect) {
		var	a	=	[] as [CGRect]
		let	all	=	glyphs.withUnsafeBufferPointer { (p:UnsafeBufferPointer<CGGlyph>) -> CGRect in
			let	num	=	glyphs.count
			var	rsp	=	UnsafeMutablePointer<CGRect>.alloc(num)
			let	all	=	CTFontGetBoundingRectsForGlyphs(self, orientation, p.baseAddress, rsp, CFIndex(glyphs.count))
			
			precondition(all != CGRectNull)
			a		=	copyMemoryToArray(rsp, num)
			rsp.dealloc(num)
			return	all
		}
		return	(a, all)
	}
	func advancesForGlyphs(glyphs:[CGGlyph], orientation:CTFontOrientation) -> (items:[CGSize], union:CGFloat) {
		var	a	=	[] as [CGSize]
		let	all	=	glyphs.withUnsafeBufferPointer { (p:UnsafeBufferPointer<CGGlyph>) -> Double in
			let	num	=	glyphs.count
			var	rsp	=	UnsafeMutablePointer<CGSize>.alloc(num)
			let	all	=	CTFontGetAdvancesForGlyphs(self, orientation, p.baseAddress, rsp, CFIndex(glyphs.count))
			
			a		=	copyMemoryToArray(rsp, num)
			rsp.dealloc(num)
			return	all
		}
		return	(a, CGFloat(all))
	}
	func advanceForGlyph(glyph:CGGlyph, orientation:CTFontOrientation) -> CGFloat {
		return	advancesForGlyphs([glyph], orientation: orientation).union
	}

}







extension CTFont {
	
	func pathForGlyph(glyph:CGGlyph) -> CGPath {
		return	CTFontCreatePathForGlyph(self, glyph, nil)!
	}
	func pathForGlyph(glyph:CGGlyph, transform:CGAffineTransform) -> CGPath {
		var	t	=	transform
		return	CTFontCreatePathForGlyph(self, glyph, &t)!
	}
	
	func drawGlyphs(glyphs:[CGGlyph], positions:[CGPoint], count:Int, context:CGContextRef) {
		glyphs.withUnsafeBufferPointer { (pgs:UnsafeBufferPointer<CGGlyph>) -> () in
			positions.withUnsafeBufferPointer({ (pps:UnsafeBufferPointer<CGPoint>) -> () in
				CTFontDrawGlyphs(self, pgs.baseAddress, pps.baseAddress, count, context)
				()
			})
			()
		}
	}
	
}















private func copyMemoryToArray<T>(p:UnsafePointer<T>, length:Int) -> [T] {
	var	a	=	[] as [T]
	for i in 0..<length {
		a.append(p[i])
	}
	return	a
}






