//
//  Editing.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph

public class Editing {
	public let	currentFileURL		=	ValueChannel<NSURL?>(nil)
	
	///	MARK:	-
	
	internal weak var owner	:	Workspace?
	internal init() {
	}
}
