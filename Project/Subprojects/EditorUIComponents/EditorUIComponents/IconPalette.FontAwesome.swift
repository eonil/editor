//
//  IconPalette.FontAwesome.swift
//  EditorUIComponents
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit




public extension IconPalette {
	///	FontAwesome.
	///	http://fortawesome.github.io/Font-Awesome/icons/
	///
	///	Licensed under SIL OFL 1.1 or CC BY 3.0
	public struct FontAwesome {
		
		public struct WebApplicationIcons {
			public static let	adjust					=	icon(0xf042)
			
			public static let	ban						=	icon(0xf05e)
			public static let	bars					=	icon(0xf0c9)
			public static let	bullseye				=	icon(0xf140)
			
			public static let	check					=	icon(0xf00c)
			public static let	checkCircle				=	icon(0xf058)
			public static let	checkCircleO			=	icon(0xf05d)
			
			public static let	comment					=	icon(0xf075)
			public static let	commentO				=	icon(0xf0e5)
			
			public static let	cube					=	icon(0xf1b2)
			public static let	cubes					=	icon(0xf1b3)
			
			public static let	database				=	icon(0xf1c0)
			
			public static let	exclamation				=	icon(0xf12a)
			public static let	exclamationCircle		=	icon(0xf06a)
			public static let	exclamationTriangle		=	icon(0xf071)
			
			public static let	folder					=	icon(0xf07b)
			public static let	folderO					=	icon(0xf114)
			public static let	folderOpen				=	icon(0xf07c)
			public static let	folderOpenO				=	icon(0xf115)
			
			public static let	info					=	icon(0xf129)
			public static let	infoCircle				=	icon(0xf05a)
			
			public static let	mapMarker				=	icon(0xf041)
			
			public static let	minusCircle				=	icon(0xf056)
			public static let	plusCircle				=	icon(0xf055)
			
			public static let	moonO					=	icon(0xf186)
			
			public static let	tag						=	icon(0xf02b)
			public static let	tags					=	icon(0xf02c)
			public static let	terminal				=	icon(0xf120)
			
			public static let	question				=	icon(0xf128)
			public static let	questionCircle			=	icon(0xf059)
			
			public static let	search					=	icon(0xf002)
			
			public static let	star					=	icon(0xf005)
			public static let	starO					=	icon(0xf006)
			
			public static let	warning					=	exclamationTriangle
		}
		
		public struct DirectionalIcons {
			public static let	angleDoubleRight		=	icon(0xf101)
			
			public static let	arrowRight				=	icon(0xf061)
			
			public static let	angleRight				=	icon(0xf105)
			
			public static let	caretRight				=	icon(0xf0da)
			
			public static let	chevronRight			=	icon(0xf054)
		}
		
	}
}




public struct FontIconDefinition: Icon {
	///	Unicode code-point that designate an icon glyph.
	public let	codePoint:UnicodeScalar
	
	///	This is vector image that will be rasterised automatically.
	public let	image:NSImage
	
	init(font:NSFont, codePoint:UnicodeScalar) {
		self.codePoint	=	codePoint
		self.image		=	IconUtility.vectorIconForCharacter(codePoint, font: font)
	}
}











private func icon(codePoint:Int) -> FontIconDefinition {
	return	icon(UnicodeScalar(codePoint))
}
private func icon(codePoint:UnicodeScalar) -> FontIconDefinition {
	struct storage {
		static let font		=	loadFont(64)
	}
	return	FontIconDefinition(font: storage.font, codePoint: codePoint)
}






private func loadFont(size:CGFloat) -> CTFont {
	let	b	=	NSBundle(forClass: MARKER.self)
	let	u	=	b.URLForResource(FONT_NAME, withExtension: "otf")!
	let	fs	=	CTFontManagerCreateFontDescriptorsFromURL(u)!
	let	fs1	=	fs as! [CTFontDescriptorRef]
	for f in fs1 {
		let	n	=	CTFontDescriptorCopyAttribute(f, NSFontNameAttribute)! as! NSString as String
		if n == FONT_NAME {
			return	CTFontCreateWithFontDescriptor(f, size, nil)
		}
	}
	fatalError("Cannot find a proper font from the bundle resource.")
}

private let	FONT_NAME	=	"FontAwesome"

@objc
private final class MARKER {
}












