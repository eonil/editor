//
//  CommonFont.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/11/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

public struct CommonFont {
	public static func codeFontOfSize(size: CGFloat) -> NSFont {
		return	NSFont(name: "Menlo", size: size)!
	}
}