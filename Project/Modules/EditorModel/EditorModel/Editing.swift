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
	public let		currentFileURL	=	EditableValueStorage<NSURL?>(nil)
	public let		selection	=	Selection()
}

public class Selection {
	public var editingFileURL: ValueStorage<NSURL?> {
		get {
			return	_editing
		}
	}
	
	private let	_editing	=	EditableValueStorage<NSURL?>(nil)
}

