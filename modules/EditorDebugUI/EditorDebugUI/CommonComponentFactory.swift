//
//  CommonComponentFactory.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

struct CommonComponentFactory {
	static func instantiateNodeTextField() -> NSTextField {
		let	v		=	NSTextField()
		v.bezeled		=	false
		v.backgroundColor	=	NSColor.clearColor()
//		v.maximumNumberOfLines	=	1	//<	Only for 10.11+.
		v.lineBreakMode		=	NSLineBreakMode.ByTruncatingTail
		return	v
	}
	
	
	
	

}