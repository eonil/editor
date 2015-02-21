//
//  IconPalette.Unicode.swift
//  EditorUIComponents
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

public extension IconPalette {
	public struct Unicode {
		public struct MiscellaneousSymbols {
			public static let	radioactive			=	icon(0x2622)
			
			public static let	whiteDiamonSuit		=	icon(0x2662)
			public static let	recyclingSymbolForGenericMaterials		=	icon(0x267A)
		}
	}
}




private func icon(code:Int) -> FontIconDefinition {
	return	FontIconDefinition(font: NSFont.systemFontOfSize(128), codePoint: UnicodeScalar(code))
}