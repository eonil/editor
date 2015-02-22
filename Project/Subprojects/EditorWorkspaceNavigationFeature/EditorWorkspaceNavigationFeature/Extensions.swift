//
//  Extensions.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/22.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

extension NSURL {
	func URLByAppendingPath(path:WorkspacePath) -> NSURL {
		if path.components.count == 0 {
			return	self
		}
		let	u	=	self.URLByAppendingPath(path.parentPath)
		let	u1	=	u.URLByAppendingPathComponent(path.components.last!)
		return	u1
	}
}