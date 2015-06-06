
//
//  Tools.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph
import EditorToolComponents


public class Toolbox {
	public let	racer	=	Racer()
	public let	cargo	=	Cargo()

	public var workspace: Workspace {
		get {
			return	owner!
		}
	}
	
	///
	
	internal weak var owner	:	Workspace?
	internal init() {
		racer.owner	=	self
		cargo.owner	=	self
	}
}
