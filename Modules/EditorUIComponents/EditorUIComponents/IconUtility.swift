//
//  IconUtility.swift
//  EditorUIComponents
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

public struct IconUtility {
	
	///	Creates a vector icon from single "Unicode code point" from supplied font.
	///	Keeps font metrics like ascent/descent, so the image will be padded properly
	///	at top and bottom in Y axis. There's no padding in X axis in concept.
	///
	///	Though produced image is represented as vector data, it need to be rasterised
	///	into bitmap to be displayed, and this rasterisation will be affected by
	///	`cacheMode` setting.
	public static func vectorIconForCharacter(codePoint:UnicodeScalar, font:CTFont) -> NSImage {
		let	gs	=	font.glyphsForCharacters(String(codePoint))
		
		precondition(gs.count == 1)
		let	g	=	gs[0]
		let	a	=	font.advancesForGlyphs(gs, orientation: CTFontOrientation.OrientationDefault).union
		let	p	=	font.pathForGlyph(g)
		let	sz	=	CGSize(width: ceil(a), height: font.size)
		
		let	m	=	NSImage(size: sz, flipped: false) { (frame:NSRect) -> Bool in
			let	p1	=	NSGraphicsContext.currentContext()!.graphicsPort
			let	ctx	=	unsafeBitCast(p1, CGContextRef.self)
			let	ps	=	(0..<gs.count).map({ _ in CGPoint(x: 0, y: font.descent) })
			font.drawGlyphs(gs, positions: ps, count: gs.count, context: ctx)
			return	true
		}
		assert(m.cacheMode == NSImageCacheMode.Default)
		return	m
	}
	
	
	
	
	
	
//
//
//	///	:param:	paddingForAntiAlias
//	///			If this is `true`, 1 point padding will be added for all edges.
//	///			This is required to render anti-alising correctly.
//	///			1 "point" is added instead of 1 "pixel" to simplify calculation.
//	private static func vectorIconForCharacter(character:Character, font:CTFont, paddingForAntiAlias:Bool) -> NSImage {
//		let	gs	=	font.glyphsForCharacters(String(character))
//
//		precondition(gs.count == 1)
//		let	g	=	gs[0]
//		let	a	=	font.advancesForGlyphs(gs, orientation: CTFontOrientation.OrientationDefault).union
//		let	p	=	font.pathForGlyph(g)
//
//		let	sz1	=	CGSize(width: ceil(a), height: font.size)
//		let	sz2	=	paddingForAntiAlias ? CGSize(width: sz1.width + 2, height: sz1.height + 2) : sz1
//
//		let	m	=	NSImage(size: sz2, flipped: false) { (frame:NSRect) -> Bool in
//			let	p1	=	NSGraphicsContext.currentContext()!.graphicsPort
//			let	ctx	=	unsafeBitCast(p1, CGContextRef.self)
//			let	ps	=	(0..<gs.count).map({ _ in CGPoint(x: paddingForAntiAlias ? 1 : 0, y: font.descent) })
//			font.drawGlyphs(gs, positions: ps, count: gs.count, context: ctx)
//			return	true
//		}
//
//	//	println(font.ascent)
//	//	println(font.descent)
//	//	println(font.ascent + font.descent)
//	//	println(font.size)
//	//	println(m)
//		return	m
//	}
}