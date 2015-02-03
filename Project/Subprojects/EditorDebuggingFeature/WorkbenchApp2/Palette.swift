//
//  Palette.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit







struct Palette {
	static let	defaultFontSize		=	CGFloat(10)
	static let	defaultLineHeight	=	CGFloat(14)
	
	static func defaultFont() -> NSFont {
		return	NSFont.systemFontOfSize(defaultFontSize)
	}
	static func defaultBoldFont() -> NSFont {
		return	NSFont.boldSystemFontOfSize(defaultFontSize)
	}
}