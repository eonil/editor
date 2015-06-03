//
//  Path.swift
//  EditorUIComponents
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

extension CGPath {
	var	boundingBox:CGRect {
		get {
			return	CGPathGetBoundingBox(self)
		}
	}
}
