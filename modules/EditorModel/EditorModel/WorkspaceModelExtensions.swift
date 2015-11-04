//
//  WorkspaceModelExtensions.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/16.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

extension WorkspaceModel: CustomStringConvertible {
	public var description: String {
		get {
			let	ptr	=	unsafeAddressOf(self)
			let	addr	=	self.location?.absoluteString ?? "(nil)"
			return	"(WorkspaceModel: \(ptr), \(addr)))"
		}
	}
}

