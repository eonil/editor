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
		_ui.model	=	_model
		_ui.run()
	}

	public func halt() {
		_ui.halt()
		_ui.model	=	nil
	}

	///

	private let	_ui		=	WorkspaceWindowUIController()
	private let	_model		=	Model()
}