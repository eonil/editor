//
//  IdentityBox.swift
//  EonilCancellableBlockingIO
//
//  Created by Hoon H. on 11/8/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

///	Provides identity to non-identifiable objects including closures.
public final class IdentityBox<T> {
	public let	value:T
	public init(value:T) {
		self.value	=	value
	}
}