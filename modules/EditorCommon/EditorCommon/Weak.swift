//
//  Weak.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public struct Weak<T: AnyObject> {
	public init(_ object: T?) {
		self.object	=	object
	}
	public weak var object: T?
}