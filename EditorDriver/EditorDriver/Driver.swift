//
//  Driver.swift
//  EditorDriver
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorModel
import EditorShell

public class Driver {

	public init() {

	}

	///

	public func run() {
		_root.run()
	}

	public func halt() {
		_root.halt()
	}

	///

	private let	_root		=	WorkspaceWindowUIController()
}